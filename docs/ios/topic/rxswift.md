### RxSwift

An API for asynchronous programming with observable streams

使用Observable流 实现了 异步编程的api。开发过程中，主要使用了 Observer模式，使用函数式编程。

#### 几个核心概念：

- Observable
- Observer
- Subject (既是Observeable 又是 Observer)
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

#### 冷、热 Obsrvable
Hot and Cold Observable

[官方介绍](https://github.com/ReactiveX/RxSwift/blob/master/Documentation/HotAndColdObservables.md)

```
When does an Observable begin emitting its sequence of items? It depends on the Observable. A “hot” Observable may begin emitting items as soon as it is created, and so any observer who later subscribes to that Observable may start observing the sequence somewhere in the middle. A “cold” Observable, on the other hand, waits until an observer subscribes to it before it begins to emit items, and so such an observer is guaranteed to see the whole sequence from the beginning.
```
Variable、ControlProperty、ControlEvent、Driver等都是 Hot Observable 。不管有没有订阅者，都会发出 element 。Observable 中一般会有多个 element 。会共享状态变化。

Async Operation、Http Connection等是 Cold Observable 。有了订阅者后才会发出 element 。Observable 一般只有一个 element。不会共享状态变化。

### 参考

- https://beeth0ven.github.io/RxSwift-Chinese-Documentation/content/why_rxswift.html
- RxJS https://rxjs-cn.github.io/learn-rxjs-operators/operators/multicasting/share.html