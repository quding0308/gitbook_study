## iOS App运行

## 启动流程

1. 加载 App 可执行文件

2. 加载 dyld 和 动态链接库

dyld 是专门用来加载动态链接库的库。dyld 从App 可执行文件的依赖开始，递归加载所有依赖的动态链接库

### ImageLoader

App 可执行文件 和 动态库 都是 image 文件。每一个 image 文件对应一个 ImageLoader 实例来负责加载。

### 动态库加载流程
1. load dylib image 
2. rebase image
3. bind image
4. objc setup
5. initializers

#### load dylib image

读取动态链接库，加载到内存

1. 分析依赖的动态库
2. 打开文件，验证签名
3. 动态库的每个 segment 调用 mmap() 映射到内存

#### rebase/bind

使用 ASLR 技术，每次 dylib 会加载到新的随机地址(actual_address)，代码和数据中原来指向的旧地址(preferred_address)。dyld 需要纠正新旧地址的偏差(slide)，这个过程就叫 rebase，做法就是把 dylib 中代码和数据的指针地址都加上这个偏移量。  

> slide = actual_address - preferred_address

rebase 操作：把 image 读入内存，并对 dylib 中的指针地址纠正偏移量。 rebase 主要瓶颈在 I/O 操作。

binding 操作 是处理dylib中指向外部的指针。从 可执行文件中的 __LINKEDIT 中读取需要 bind 的指针 和 指针指向的符号，然后从符号表中查找对应实现，将实现存储到 __DATA 中的那个指针。 binding 操作需要大量 CPU 计算。

#### objc setup

**1. 注册 objc 类** 

class registration

objc runtime 维护着一张 映射 类名和类的全局表。当加载一个 dylib 时，其定义的所有类都需要被注册到全局表中

**2. 把category的定义插入方法列表**

category registration

class 加载完后，会加载 category 。把 category 中定义的方法都加在到 方法列表中。

**3. 保证每一个 selector 唯一**



#### initializers

**1. objc 的 +load 函数**

可执行文件 和 动态库 加载完，并且 执行完  objc setup 后，可执行文件中和动态库所有的符号(Class，Protocol，Selector，IMP，…)都已经按格式成功加载到内存中，被 runtime 所管理。在这之后，runtime 的那些方法(动态添加 Class、swizzle 等等才能生效)




## Linux 加载可执行目标文件

运行时内存映像：
```
内存内核
======= 2^48-1 地址
用户栈(运行时创建)
...
...      <- 栈指针
=======

共享库的内存映射区域(动态库)

=======  <- 堆内存
...
...
运行时堆(由malloc创建)
=======
读/写段
.data, .bss
-------
只读代码段
(.init, .text, .rodata)
======= 0x400000
        0
```



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


### 参考
- https://techblog.toutiao.com/2018/05/29/untitled-24/
- http://yulingtianxia.com/blog/2016/10/30/Optimizing-App-Startup-Time/
- http://blog.sunnyxx.com/2014/08/30/objc-pre-main/
- 
