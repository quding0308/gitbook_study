## Selector

### runtime api
```
sel_getName
    Returns the name of the method specified by a given selector.
sel_registerName
    Registers a method with the Objective-C runtime system, maps the method name to a selector, and returns the selector value.
sel_getUid
    Registers a method name with the Objective-C runtime system.
sel_isEqual
    Returns a Boolean value that indicates whether two selectors are equal.
```

## @selector 原理

### 结论：

1. ObjC setup 时创建了一 hastable，key 为 (char *)name， value 为 SEL ，一个内存地址(intptr_t)。
2. 在使用 @selector() 时会从这个表中根据名字查找对应的 SEL 。如果没有找到，则会生成一个 SEL 并添加到表中
3. 在编译期间会扫描全部的头文件和实现文件将其中的方法以及使用 @selector() 生成的选择子加入到选择子表中
4. 每个 SEL 实际是一个 内存地址 intptr_t。而该地址指向的是 c 的字符串 (char *)

### 源码实现

```
typedef intptr_t SEL

// 两个指针知否指向同一个内存地址
BOOL sel_isEqual(SEL lhs, SEL rhs)
{
    return bool(lhs == rhs);
}

// 直接读取 char* 为名字
const char *sel_getName(SEL sel) 
{
    if (!sel) return "<null selector>";
    return (const char *)(const void*)sel;
}

// 注册selector
SEL sel_registerName(const char *name) {
    return __sel_registerName(name, 1, 1);     // YES lock, YES copy
}

static SEL __sel_registerName(const char *name, int lock, int copy) 
{
    SEL result = 0;

    if (lock) selLock.assertUnlocked();
    else selLock.assertWriting();

    if (!name) return (SEL)0;
    
    // 多加了一层 cache 。 enable dyld shared cache optimizations
    result = search_builtins(name);
    if (result) return result;
    
    if (lock) selLock.read();
    // 从 hashtable 中读取值
    if (namedSelectors) {
        result = (SEL)NXMapGet(namedSelectors, name);
    }
    if (lock) selLock.unlockRead();
    if (result) return result;

    // No match. Insert.

    if (lock) selLock.write();

    // 第一次，要创建 hashtable
    if (!namedSelectors) {
        namedSelectors = NXCreateMapTable(NXStrValueMapPrototype, 
                                          (unsigned)SelrefCount);
    }
    if (lock) {
        // Rescan in case it was added while we dropped the lock
        result = (SEL)NXMapGet(namedSelectors, name);
    }

    // 在 hashtabe 中增加键值对 key 为 char*， value 为 SEL 
    if (!result) {
        result = sel_alloc(name, copy);
        // fixme choose a better container (hash not map for starters)
        NXMapInsert(namedSelectors, sel_getName(result), result);
    }

    if (lock) selLock.unlockWrite();
    return result;
}

/// 初次初始化，调用了 sel_registerNameNoLock
SEL sel_registerNameNoLock(const char *name, bool copy) {
    return __sel_registerName(name, 0, copy);  // NO lock, maybe copy
}
```

### 何时会添加 selector 

#### ObjC init 时，初始化基本的 selector

// 首次 初始化 selector table 并且把上面读取的 SEL 注册到 table 中
// Initialize selector tables and register selectors used internally
sel_init(wantsGC, selrefCount); 中注册了部分 SEL

```
void sel_init(bool wantsGC, size_t selrefCount)
{
#define s(x) SEL_##x = sel_registerNameNoLock(#x, NO)
#define t(x,y) SEL_##y = sel_registerNameNoLock(#x, NO)

    sel_lock();

    s(load);
    s(initialize);
    t(resolveInstanceMethod:, resolveInstanceMethod);
    t(resolveClassMethod:, resolveClassMethod);
    t(.cxx_construct, cxx_construct);
    t(.cxx_destruct, cxx_destruct);
    s(retain);
    s(release);
    s(autorelease);
    s(retainCount);
    s(alloc);
    t(allocWithZone:, allocWithZone);
    s(dealloc);
    s(copy);
    s(new);
    s(finalize);
    t(forwardInvocation:, forwardInvocation);
    t(_tryRetain, tryRetain);
    t(_isDeallocating, isDeallocating);
    s(retainWeakReference);
    s(allowsWeakReference);

    sel_unlock();
#undef s
#undef t
}
```

#### 运行时

调用 @selector 或 NSSelectorFromString() 时，如果在 hashtabel 中不存在 则会新增到 hashtable 中

