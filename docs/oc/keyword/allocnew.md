# alloc 与 new 比较

结论：
- new 包含了 alloc + init ，无法调用其他 init 方法
- alloc 会调用 allocWithZone ，new 会调用 alloc 注意：在 Objective C 2.0 中，allocWithZone: 的 zone 参数会被忽略掉。


### alloc

``` c
+ (id)alloc {
    return _objc_rootAlloc(self);
}

id _objc_rootAlloc(Class cls) {
    return callAlloc(cls, false/*checkNil*/, true/*allocWithZone*/);
}

callAlloc 函数最终会调用 class_createInstance(cls, 0) 创建一个对象实例。

在 class_createInstance 函数中会调用 calloc 分配内存，然后设置 isa 指针。

```


### init
``` c
+ (id)init {
    return (id)self;
}
```


### new 
``` c
+ (id)new {
    return [callAlloc(self, false/*checkNil*/, false/*allocWithZone*/) init];
}
```




