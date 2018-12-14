### objc-start

```
void _objc_init(void)
{
    static bool initialized = false;
    if (initialized) return;
    initialized = true;
    
    // 各种初始化
    environ_init();
    tls_init();
    static_init();
    lock_init();
    // 看了一下exception_init是空实现！！就是说objc的异常是完全采用c++那一套的。
    exception_init();
   // 注册dyld事件的监听
    _dyld_objc_notify_register(&map_2_images, load_images, unmap_image);
}
```

初始化流程：

1. class从二进制里面读出来 加载到一个全局的map中
2. 分别读取每个class，初始化

初始化流程：
1. fix selector 唯一性
2. 读取 protocol
3. 读取class
4. attach category

子类的 load 方法会在父类方法执行完成之后执行，分类的 +load 会在主类执行之后执行。

Category 中的方法列表加到 Class 的 methed_list_t 里面去。而且是插入到 Class 方法列表的前面（这就是 Category 中重写主类的方法导致的方法覆盖的原因）
