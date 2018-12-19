

### 底层实现原理
- block 底层实现
- runtime 和 对象模型
- observer 的实现

网络
- http 知识复习。raw 拷贝一份 懂
- https 原理清晰。几个 role，cert 怎么流转，加密方式
- tcp 原理描述 
    - 基于mars 改进 相比 websocket 的优点
    - websocket 基本原理，在 有赞的 优化点？
    - mars 相比 socket tcp，做了哪些优化点？
- App网络优化
    - http://blog.cnbang.net/tech/3531/

数据库
- wcdb 相比直接使用 fmdb 的优点，解决了之前的哪些坑？
- wcdb 的基本原理，项目中怎么用？
- protobuf 与 现在项目中技术方案比较？
- 索引的建立 优缺点
- 表的拆分？

轻应用
- 负责承载基础业务
- wk的一些基础api
- 相比于 UIWebView的一些优势
- 开发 混合应用的 整个思考过程，相比较VaSonic 的使用？  【查看最新版本】
- 首页秒开探索：http://blog.cnbang.net/tech/3477/

IM 的相关策略
- 如何保证可达性？
- 如何尽快拉取？
- 等 文档里的描述  总结成可以说的问题

UI渲染流程，事件响应机制
- 卡顿问题
- 如何监测
- Autolayout 的使用
- UIStackView 的常见使用？我为什么没有用？
- 动画
    - lottie 库的使用，常见问题
    - pop库的使用
- Texture 中提供的优化思路
- gif动画播放原理 以及 压缩思路

内存问题
- 如何分配？
- 如何检测泄露
- 如何监测内存占用？
- 如何优化内存，常见思路？
    - FBRetainCycleDetector
    - MLeaksFinder

底层问题
- oc部分底层实现原理
- CoreText问题  Text绘制慢，如何优化？
- runtime
    - 对象模型
    - 动态特性
- 锁、GCD、RunLoop

其他框架：
- promisekit
- rxswift
- SDWebImage
- YYCache的缓存设计 如果自己设计一个缓存系统？
- App启动时间优化 以及 启动时做了什么
- 编译流程
- iOS签名原理：http://blog.cnbang.net/tech/3386/   【绘制一张mindmap】
- 线程 和 进程 的不同  Android单启动一个进程，面向进程编程的不同？

检测、量化 -> 瓶颈 -> 优化


😋
- 启动流程
- 运行时与对象模型
- map 与 flatmap
- differentor 的使用，tableview 优化 再整理下
- block

### new 与 alloc 区别

```
// 使用 _zoneAlloc 分配内存，自己显示调用 initXX 来初始化对象
+ alloc {
    return (*_zoneAlloc)((Class)self, 0, malloc_default_zone());
}

// 使用 _alloc 分配内存，只能使用 init 初始化对象
+ new {
    id newObject = (*_alloc)((Class)self, 0);
    Class metaClass = self->isa;
    if (class_getVersion(metaClass) > 1)
        return [newObject init];
    else
        return newObject;
}

- init {
    return self;
}

补充： NSZone是Apple用来分配和释放内存的一种方式，它不是一个对象，而是使用C结构存储了关于对象的内存管理的信息。iOS App 使用一个系统默认的NSZone来对应用的对象进行管理，会对内存做一定优化，减少内存碎片。

```

### nil 输出到 字符串中为 (null)

```
NSString *str = nil;
NSString *result = [NSString stringWithFormat:@"result:%@", str];

输出：
result:(null)

////////
其他为nil 的对象
MyKey *str = nil;
NSString *result = [NSString stringWithFormat:@"result:%@", str];

输出：
result:(null)
```
