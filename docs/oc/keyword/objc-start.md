## objc-start

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


### load 与 initialize 

load 是在被添加到 runtime 时开始执行，父类最先执行，然后是子类，最后是 Category。又因为是直接获取函数指针来执行，不会像 objc_msgSend 一样会有方法查找的过程。

+ initialize 不会被调用。类接收消息时，运行时会先检查 + initialize 有没有被调用过。如果没有，会在消息被处理前调用

+ initialize 最终是通过 objc_msgSend 来执行的，objc_msgSend 会执行一系列方法查找，并且 Category 的方法会覆盖类中的方法。

### 参考
- https://juejin.im/entry/5837a4fac59e0d006b2ab8d5
- http://blog.leichunfeng.com/blog/2015/05/02/objective-c-plus-load-vs-plus-initialize/
