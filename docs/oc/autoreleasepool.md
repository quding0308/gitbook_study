### autoreleasepool

### 插入了什么代码？对obj 怎么处理？

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

更进一步
```
- 调用 AutoreleasePoolPage::push() 会生成
- 当对象调用 autorelease 方法时，会将对象加入 AutoreleasePoolPage 的栈中
- 调用 AutoreleasePoolPage::pop 方法会向栈中的对象发送 release 消息

void *objc_autoreleasePoolPush(void) {
    return AutoreleasePoolPage::push();
}
void objc_autoreleasePoolPop(void *pool) {
    AutoreleasePoolPage::pop(pool);
}
```


### 底层实现原理
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

自动释放池是由 AutoreleasePoolPage 以双向链表的方式实现的。每一个自动释放池都是由一系列的 AutoreleasePoolPage 组成，并且每一个 AutoreleasePoolPage 的大小都是 4096 字节

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
   // hotPage 为当前正在使用的 AutoreleasePoolPage
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




### 小结


```
// 把value加到最靠近的autorelease pool中，回调用 [value autorelease]
id objc_autorelease(id obj) {
    if (!obj) return obj;
    if (obj->isTaggedPointer()) return obj;
    return obj->autorelease();
}


id objc_autoreleaseReturnValue(id value) {
    // if (prepareOptimizedReturn(ReturnAtPlus1)) return obj;

    return objc_autorelease(obj);
}

@autoreleasepool {
    // 
}
```


### 参考

- https://draveness.me/autoreleasepool