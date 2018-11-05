### autoreleasepool

### 插入了什么代码

代码：
```
@autoreleasepool {
    //
}
```

编译后的代码：
```
void* pool = objc_autoreleasePoolPush();
// do sth
// objc_autorelease(obj);
objc_autoreleasePoolPop(pool);
```

更进一步：
```
- 调用 AutoreleasePoolPage::push() 会返回 一个哨兵对象的地址，这个地址就是 一个 pool 的开端
- 当对象调用 autorelease 方法时，会将对象加入 AutoreleasePoolPage 的栈中
- 调用 AutoreleasePoolPage::pop 方法会向栈中的对象发送 release 消息

void *objc_autoreleasePoolPush(void) {
    return AutoreleasePoolPage::push();
}
void objc_autoreleasePoolPop(void *pool) {
    AutoreleasePoolPage::pop(pool);
}
```


### 底层实现

整个App的pool 底层都使用一个双向练笔实现

自动释放池是由 AutoreleasePoolPage 以双向链表的方式实现的。

每一个自动释放池都是由一系列的 AutoreleasePoolPage 组成，并且每一个 AutoreleasePoolPage 的大小都是 4096 字节。

App中的所有自动释放池都存储在同一个双向链表中，一个自动释放池的开头是 哨兵对象的，存储了一个nil对象。

#### AutoreleasePoolPage
```
class AutoreleasePoolPage {
    magic_t const magic;
    id *next;
    pthread_t const thread; // 当前page所在的线程
    AutoreleasePoolPage * const parent; // 用来构造双向链表
    AutoreleasePoolPage *child; // 双向链表
    uint32_t const depth;
    uint32_t hiwat;
};
```

#### AutoreleasePoolPage::push()

```
static inline void *push() {
   return autoreleaseFast(POOL_SENTINEL);   // POOL_SENTINEL为哨兵
}

/*
    有 hotPage 并且当前 page 不满
        调用 page->add(obj) 方法将对象添加至 AutoreleasePoolPage 的栈中
    有 hotPage 并且当前 page 已满
        调用 autoreleaseFullPage 初始化一个新的页
        调用 page->add(obj) 方法将对象添加至 AutoreleasePoolPage 的栈中
    无 hotPage
        调用 autoreleaseNoPage 创建一个 hotPage
        调用 page->add(obj) 方法将对象添加至 AutoreleasePoolPage 的栈中
    最后的都会调用 page->add(obj) 将对象添加到自动释放池中。
*/
static inline id *autoreleaseFast(id obj)
{
   AutoreleasePoolPage *page = hotPage();
   if (page && !page->full()) {
       return page->add(obj);
   } else if (page) {
       return autoreleaseFullPage(obj, page);
   } else {
       return autoreleaseNoPage(obj);
   }
}

// hotPage已满
static id *autoreleaseFullPage(id obj, AutoreleasePoolPage *page) {
    do {
        if (page->child) page = page->child;
        else page = new AutoreleasePoolPage(page);
    } while (page->full());
    setHotPage(page);
    return page->add(obj);
}

// 没有hotPage
static id *autoreleaseNoPage(id obj) {
    AutoreleasePoolPage *page = new AutoreleasePoolPage(nil);
    setHotPage(page);
    if (obj != POOL_SENTINEL) {
        page->add(POOL_SENTINEL);
    }
    return page->add(obj);
}

// page->add(obj)  压栈操作
id *add(id obj) {
    id *ret = next;
    *next = obj;
    next++;
    return ret;
}

```

#### AutoreleasePoolPage::pop(ctxt);

遍历双向链表中的所有page对象，对page中存储的obj 出栈 分别做release操作
```
static inline void pop(void *token) {
    AutoreleasePoolPage *page = pageForPointer(token);
    id *stop = (id *)token;

    page->releaseUntil(stop);

    if (page->child) {
        if (page->lessThanHalfFull()) {
            page->child->kill();
        } else if (page->child->child) {
            page->child->child->kill();
        }
    }
}
```




### 其他
#### 使用容器的block版本的枚举器时，内部会自动添加一个AutoreleasePool：
```
[array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    // 这里被一个局部@autoreleasepool包围着
}];
```
当然，在普通for循环和for in循环中没有，所以，还是新版的block版本枚举器更加方便。for循环中遍历产生大量autorelease变量时，就需要手加局部AutoreleasePool。

### 参考

- https://draveness.me/autoreleasepool
- https://blog.sunnyxx.com/2014/10/15/behind-autorelease/