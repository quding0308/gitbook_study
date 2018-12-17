## YYAsyncLayer

几个核心类：
- YYAsyncLayer：继承自CALayer，绘制、创建绘制线程的部分都在这个类。
- YYTransaction：用于创建 RunloopObserver 监听 MainRunloop 的空闲时间，并将 YYTranaction 对象存放到集合中。
- YYSentinel：提供获取当前值的value（只读）属性，以及 -(int32_t)increase 自增加的方法返回一个新的value值，用于判断异步绘制任务是否被取消的工具。


https://www.jianshu.com/p/7a353962b3d8


### 参考
- https://www.jianshu.com/p/7a353962b3d8
- https://github.com/ibireme/YYAsyncLayer