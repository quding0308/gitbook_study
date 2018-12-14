### runloop


### 一些疑问

- RunLoop在系统中所处的角色
- RunLoop具体作用是什么？有没有其他类似的机制可以代替角色？
- 每个线程都对应一个RunLoop对象吗？
- RunLoop 有哪些事件？如何监听？
- RunLoop 具体可以设置什么property？分别有什么作用？设置的属性 怎么起作用的？实质是与系统交互的api
- 实际工作中 有哪些经典实用？卡顿监听？asynckit中的经典实用？autoreleasepool、触摸事件的处理？
- mainRunLoop 与 其他RunLoop的区别？有哪些特权？
- 具体如何运转？


### Runloop 简介
所谓 Runloop 就是 苹果设计的一种 **在当前线程，持续调度各种任务** 的运行机制。

伪代码：
``` Swift 
while(alive) {
    performTask() // 执行任务
    call_to_observer() // 回调 通知外部当前处于哪个阶段
    sleep() // 休眠
}
```

### Runloop 的 mode

Runloop 运行时只可能处于一个mode模式(currentMode)，切换mode时需要停止重新运行。一个 mode 可以将自己标记为”Common”属性（通过将其 ModeName 添加到 RunLoop 的 “commonModes” 中）。

iOS公开提供了两个Mode：
* UITrackingRunLoopMode
* NSDefaultRunLoopMode


```
main Runloop 中，这两个 mode 都在 commonModes 中

UITrackingRunLoopMode
界面跟踪 Mode，用于 ScrollView 追踪触摸滑动，保证界面滑动时不受其他 mode 影响

NSDefaultRunLoopMode
默认Mode，主线程是在这个Mode运行
```

**CommonMode**

一个 Mode 可以将自己标记为”Common”属性（通过将其 ModeName 添加到 RunLoop 的 “commonModes” 中）。

每当 RunLoop 的内容发生变化时，RunLoop 都会自动将 _commonModeItems 里的 Source/Observer/Timer 同步到具有 “Common” 标记的所有Mode里。

```
_commonModes存储了标记为common的mode

_commonModeItems里存储的是common mode中的Set<Source/Observer/Timer>

// 将mode标记为common   
CFRunLoopAddCommonMode(loop, mode);

实际使用：
main runloop中增加一个timer 如果只增加到  kCFRunLoopDefaultMode，则当页面滑动出发  mode：UITrackingRunLoopMode，改timer就无法被触发。此时可以把timer增加到  kCFRunLoopCommonModes，无论kCFRunLoopDefaultMode 或 UITrackingRunLoopMode 都可以触发timer
```

一个 mode 中可以添加 source、observer、timer

Runloop
* mode1
    * source0
    * source1
    * Observer
    * Timer
* mode2
    * source0
    * source1
    * Observer
    * Timer

#### Runloop 的 Observer

RunLoop可以观察的时间点：

``` Swift 
typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
    kCFRunLoopEntry = (1UL << 0), // 即将进入Loop（执行一次）
    kCFRunLoopBeforeTimers = (1UL << 1), // 即将处理 Timer
    kCFRunLoopBeforeSources = (1UL << 2), // 即将处理 Source
    kCFRunLoopBeforeWaiting = (1UL << 5), // 即将休眠
    kCFRunLoopAfterWaiting = (1UL << 6), // 刚从休眠中被唤醒
    kCFRunLoopExit = (1UL << 7) // Loop即将退出（执行一次）
};
```

添加 obsrver
``` Swift
CFRunLoopRef loop = CFRunLoopGetMain();
CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(NULL, kCFRunLoopBeforeSources, true, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
    NSLog(@"observer %lu", activity);
});
CFRunLoopAddObserver(loop, observer, kCFRunLoopCommonModes);
```

### Runloop 源码

``` Swift
struct __CFRunLoop {
    CFMutableSetRef _commonModes;     // Set<CFRunLoopMode>
    CFMutableSetRef _commonModeItems; // Set<Source/Observer/Timer>
    CFRunLoopModeRef _currentMode;    // Current Runloop Mode
    CFMutableSetRef _modes;           // Set
};

struct __CFRunLoopMode {
    CFStringRef _name;            // Mode Name, 例如 @"kCFRunLoopDefaultMode"
    CFMutableSetRef _sources0;    // Set
    CFMutableSetRef _sources1;    // Set
    CFMutableArrayRef _observers; // Array
    CFMutableArrayRef _timers;    // Array
    ...
};
```

底层存储：
``` Swift
// 获取RunLoop对象
CFRunLoopRef _CFRunLoopGet0(pthread_t t) {
    if (pthread_equal(t, kNilPthreadT)) {
        t = pthread_main_thread_np(); // t == 0 为main thread
    }

    __CFLock(&loopsLock);
    /// __CFRunLoops是一个CFDictionary对象，全局存储RunLoop，key为pthread，value为Runloop
    if (!__CFRunLoops) {
        CFMutableDictionaryRef dict = CFDictionaryCreateMutable(kCFAllocatorSystemDefault, 0, NULL, &kCFTypeDictionaryValueCallBacks);
        CFRunLoopRef mainLoop = __CFRunLoopCreate(pthread_main_thread_np());
        CFDictionarySetValue(dict, pthreadPointer(pthread_main_thread_np()), mainLoop);
        if (!OSAtomicCompareAndSwapPtrBarrier(NULL, dict, (void * volatile *)&__CFRunLoops)) {
          CFRelease(dict);
        }
        CFRelease(mainLoop);
    }

    CFRunLoopRef newLoop = NULL;
    // 从全局的Dictionary中取缓存的RunLoop对象
    CFRunLoopRef loop = (CFRunLoopRef)CFDictionaryGetValue(__CFRunLoops, pthreadPointer(t));
    if (!loop) {
        // 如果没有则新建RunLoop 【从这里可以看出，创建thread时并没有对应的RunLoop，只有主动CFRunLoopGetCurrent才会创建】
        newLoop = __CFRunLoopCreate(t);
        CFDictionarySetValue(__CFRunLoops, pthreadPointer(t), newLoop);
        loop = newLoop;
    }
    __CFUnlock(&loopsLock);
    
    // don't release run loops inside the loopsLock, because CFRunLoopDeallocate may end up taking it
    if (newLoop) { CFRelease(newLoop); }
    if (pthread_equal(t, pthread_self())) {
        _CFSetTSD(__CFTSDKeyRunLoop, (void *)loop, NULL);
        if (0 == _CFGetTSD(__CFTSDKeyRunLoopCntr)) {
             _CFSetTSD(__CFTSDKeyRunLoopCntr, (void *)(PTHREAD_DESTRUCTOR_ITERATIONS-1), (void (*)(void *))__CFFinalizeRunLoop);
        }
    }

    return loop;
}

// 获取 main Runloop
CFRunLoopRef CFRunLoopGetMain(void) {
    static CFRunLoopRef __main = NULL; // static 只会获取一次
    if (!__main) __main = _CFRunLoopGet0(pthread_main_thread_np());
    return __main;
}

// 获取当前thread对象的Runloop
CFRunLoopRef CFRunLoopGetCurrent(void) {
    CHECK_FOR_FORK();
    CFRunLoopRef rl = (CFRunLoopRef)_CFGetTSD(__CFTSDKeyRunLoop);
    if (rl) return rl;
    return _CFRunLoopGet0(pthread_self()); //#include <pthread.h> 中可以获取pthread_self
}

```

### 获取 fps

通过 CADisplayLink 或 注册 observer 每次调用时间，得出 fps

```
if (_lastTime == 0) {
    _lastTime = link.timestamp;
    return;
}

_count++;
NSTimeInterval delta = link.timestamp - _lastTime;
if (delta < 1) return;
_lastTime = link.timestamp;
float fps = _count / delta;
_count = 0;
```

### 卡顿监听

启动子线程，定时像主线程发送 ping，如果超时没有收到pong，则认为 此时主线程卡顿。获取当时的 stack trace

参考：

- http://mrpeak.cn/blog/ui-detect/
- http://ios.jobbole.com/93085/

### performSelector:afterDelay:




### 参考：
- https://blog.ibireme.com/2015/05/18/runloop/
- https://mp.weixin.qq.com/s/XbdezDo2xu-9SaSmid2pbw
- MrPeak: https://mp.weixin.qq.com/s/XbdezDo2xu-9SaSmid2pbw