### atomic




### NSAutoreleasePool



### @synchronized

具体使用：
```
NSObject* obj = [NSObject new];
@synchronized (obj) {
    //
}
```

lock底层存储：
```
// 全局哈希表 会有64个SyncList对象，会根据obj的内存地址计算出数据存储到某个SyncList中(全局哈希表 会多线程使用，处理数据的时候需要加锁。每个SyncList对象内部有自己的锁。
最多可以有64个读写同时发生)。
StripedMap<SyncList> 

// 一个链表 
struct SyncList {
    SyncData *data;
    spinlock_t lock;
};

//每个obj对应一个SyncData对象，封装了mutex
struct SyncData {
    struct SyncData* nextData;
    DisguisedPtr<objc_object> object;
    int32_t threadCount;  // number of THREADS using this block
    recursive_mutex_t mutex;    
} 

详细参考：
http://blog.quding0308.com/objc,/runtime/2018/09/11/ObjC%E4%B8%AD@synchronized%E7%9A%84%E5%AE%9E%E7%8E%B0.html
```

总结：
1. 底层使用 recursive_mutex_t 做锁操作  加锁、解锁   
2. synchronized 使用obj的内存地址作为key，通过hash map对应的一个系统维护的递归锁
3. 不要使用self作为obj，而是应该声明一个私有的obj来作为key，self 颗粒度太大。@synchronized如果控制好精度，也不会很慢。精度控制 就是 对obj的使用（如果所有的 @synchronized都使用一个obj，则就会很慢了）。不同数据应该使用不同的obj来控制在最细的粒度
4. @synchronized(nil) 不起任何作用。当obj的生命周期结束了，同步代码也就失效


