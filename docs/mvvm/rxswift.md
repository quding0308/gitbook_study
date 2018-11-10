### rxswift

An API for asynchronous programming with observable streams

使用Observable流 实现了 异步编程的api。开发过程中，主要使用了 Observer模式，使用函数式编程。

#### 几个核心概念：

- Observable
- Observer
- Subject (既是Observeable 又是 Observer)
- Driver
- Disposable
- Scheduler

详细参考： 

http://blog.quding0308.com/blog/rxswift/2018/09/17/rxswift-basic.html

#### 核心的操作 Operation ：

- 创建Observable
- 组合创建Observable
- 转换Observable
- 从Observable中发出指定元素
- 错误处理

详细参考：

http://blog.quding0308.com/blog/rxswift/2018/09/18/rxswift-operation.html

