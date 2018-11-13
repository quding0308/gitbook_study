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
