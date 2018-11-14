### 进程和线程的区别

系统级别的概念。


进程
1. 独立的内存空间、代码、数据和其他系统资源。
2. 对磁盘中资源的使用，无法通过加锁防止并发操作
3. 单例、全局变量的使用要注意
4. iOS中的widget 是 进程，

线程 是 进程内的一个独立执行单元。
1. 内存。一个进程内，有多个线程。多线程共享进程资源
2. 资源。可以使用锁来处理 临界资源的访问控制
   
主线程

进程创建后，系统会创建一个主线程，生命周期与进程一致。主线程的退出意味着进程的终止

跨进程通信：
1. rpc，Android中通过aidl文件来定义接口。
2. Android中可以通过注册 ContentProvider、调用Service、Intent 来通信

### iOS中有哪些线程锁
1. gcd
3. @synchronized()
4. property中的atomic
5. NSThread
6. NSLock
    1. 对于 NSLock 及其子类，速度来说 NSLock < NSCondition < NSRecursiveLock < NSConditionLock 。
7. pthread 
    1. pthread_mutex
    2. pthread_spin_lock

pthread_rwlock

系统级别的读写锁  读共享，写排他

与 dispatch_async_barrier 

#### 互斥锁、自旋锁、原子性、并发、并行


**动态库和静态库的区别**

22


#### data race

资源竞争，保证资源的一致性 当有写操作的时候，尤其要注意。

**正则表达式在项目中的使用**


**IM App 如何确保消息可靠抵达**

分两步：
1. client1 -> server
2. server -> client2

client1 -> server 确保发送成功

1. ack server收到了
2. 想办法尽量发送成功
    1. 长短连 混用。长连断开后 使用短连发送
    2. 超时、重试机制（mars底层 10min重试）
    3. 根据外部环境变化【网络切换、前后台切换】，进行重试
   
server -> client2 确保接收成功，数据可靠抵达

1. 长连通道 onPush 信令，根据 updateTime 【updateTime会在本地保存一份】，拉取最新消息
2. 无网络到有网络，前后台切换，会通过接口优先拉取最新消息；重新check 长连，通过发送cmd，检查最新的update time
3. 有3个通道。首先会启用 轮询机制，10 s轮询一次
4. 每个消息都有 seq

发、收消息 都依赖于tcp的可靠性

tcp 发送的每个包都有seq，收到后 会返回 ack = seq + 1，告知对方已收到。如果没有返回ack，会触发重发机制。

但 网络上的可靠性 不等同于业务层的可靠性。网络层之上的应用层也可能会失败，如何确保应用层传成功？
1. 方案1. 存入本地db认为应用层成功。成功后，像server 发送一个 ack 确认，否则 server 会重发
2. 方案2.每个message 都有 seq。 db中保存 lastReceivedSeqId。如果接收到新消息后，发现seq 不连续，就认为丢失了数据，需要重新fetch
3. 方案3.本地保存最新的updateTime(server返回的)，获取到新消息，并且存入 db 后，更新本地的updateTime。【udpateTime实际是最新一条数据的时间 】 


### property 的默认修饰符
- 对象。(atomic, strong, readwrite)
- 基本数据类型。  (atomic, assign, readwrite)

### KVO原理

#### 使用：

```
- (void)init {}
    [obj addObserver:self forKeyPath:@"obj_property_name" options:NSKeyValueChangeNewKey context:nil];
}
- (void)dealloc {
    [obj removeObserver:self forKeyPath:@"obj_property_name"];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    //
}
```

#### 具体原理
1. kvo 基于runtime 实现
2. 当Person对象的某个 property 被观察后，会重新生成一个setter 在复制的前后调用 willChangeValueForKey: 和 didChangeValueForKey: ，从而 observeValueForKey:ofObject:change:context: 也会被调用
3. 实际Person对象，会生成一个Person的子类 NSKVONotifying_Person ，然后Person对象的isa指针指向 NSKVONotifying_Person。

NSKVONotifying_Person 的set重写为：

```
- (void)setName:(NSString *)name {
    [self willChangeValueForKey: @"name"];
    [super setName: name]; // 调用父类的setName，即使我们重写了setName 也会正常调用
    [self didChangeValueForKey: @"name"];
}
```


参考：https://zhuanlan.zhihu.com/p/34273366