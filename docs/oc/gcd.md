## GCD

### 优先级

```
// 与用户交互的优先级
QOS_CLASS_USER_INTERACTIVE
// 用户发起的服务，等待结果
QOS_CLASS_USER_INITIATED
// 默认优先级
QOS_CLASS_DEFAULT
// 用户不太关心任务的进度，但需要知道结果
QOS_CLASS_UTILITY
// 后台加载
QOS_CLASS_BACKGROUND
```

global queue 的优先级
```
#define DISPATCH_QUEUE_PRIORITY_HIGH 2
#define DISPATCH_QUEUE_PRIORITY_DEFAULT 0
#define DISPATCH_QUEUE_PRIORITY_LOW (-2)
#define DISPATCH_QUEUE_PRIORITY_BACKGROUND INT16_MIN
```

对应关系：
```
*  - DISPATCH_QUEUE_PRIORITY_HIGH:         QOS_CLASS_USER_INITIATED
*  - DISPATCH_QUEUE_PRIORITY_DEFAULT:      QOS_CLASS_DEFAULT
*  - DISPATCH_QUEUE_PRIORITY_LOW:          QOS_CLASS_UTILITY
*  - DISPATCH_QUEUE_PRIORITY_BACKGROUND:   QOS_CLASS_BACKGROUND
```

```
- (void)qdGCDPriority {
dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);    

dispatch_queue_global_t gQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);

// 指定优先级创建队列
dispatch_queue_t queue1;
dispatch_queue_attr_t attr1;
attr1 = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL,
                                                QOS_CLASS_UTILITY, 0);
queue1 = dispatch_queue_create("com.example.myqueue", attr1);
NSLog(@"");
}
```

参考：http://ios.jobbole.com/90207/