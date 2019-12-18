## 同步和异步

下面的内容来自： 

https://stackoverflow.com/questions/748175/asynchronous-vs-synchronous-execution-what-does-it-really-mean 

### 解读1

When you execute something synchronously, you wait for it to finish before moving on to another task. 

When you execute something asynchronously, you can move on to another task before it finishes

### 解读2

Synchronous/Asynchronous HAS NOTHING TO DO WITH MULTI-THREADING

Synchronous, or Synchronized means "connected", or "dependent" in some way. In other words, two synchronous tasks must be aware of one another, and one task must execute in some way that is dependent on the other, such as wait to start until the other task has completed.
Asynchronous means they are totally independent and neither one must consider the other in any way, either in initiation or in execution.

Synchronous (one thread):

```
1 thread ->   |<---A---->||<----B---------->||<------C----->|
Synchronous (multi-threaded):

thread A -> |<---A---->|   
                        \  
thread B ------------>   ->|<----B---------->|   
                                              \   
thread C ---------------------------------->   ->|<------C----->| 
```

Asynchronous (one thread):

```
         A-Start ------------------------------------------ A-End   
           | B-Start -----------------------------------------|--- B-End   
           |    |      C-Start ------------------- C-End      |      |   
           |    |       |                           |         |      |
           V    V       V                           V         V      V      
1 thread->|<-A-|<--B---|<-C-|-A-|-C-|--A--|-B-|--C-->|---A---->|--B-->| 
```

Asynchronous (multi-Threaded):

```
 thread A ->     |<---A---->|
 thread B ----->     |<----B---------->| 
 thread C --------->     |<------C--------->|
```

- Start and end points of tasks A, B, C represented by <, > characters.
- CPU time slices represented by vertical bars |

### GCD 中的 sync 与 async

gcd 中的 sync 是阻塞当前线程，等待执行结果，然后当前线程继续往下执行，跟上面的两种理解都不一样。

async 是在某个线程执行任务，不阻塞当前线程。

``` swift
 class func testMain1() {
    print("=== 1")
    DispatchQueue.main.async {
        print("main 123")
    }
    
    print("=== 2")
    DispatchQueue.global().sync {
        print("global execute")
    }
    
    print("=== 3")
}

执行结果：
=== 1
=== 2
global execute
=== 3
main 123
```

注意下面的代码会导致死锁：

``` swift
class func testMain1() {
    print("=== 1")
    // 在主线程中同步执行主线程的任务会导致死锁
    DispatchQueue.main.sync {
        print("global execute")
    }
    
    print("=== 2")
}
```

### 参考

- https://stackoverflow.com/questions/748175/asynchronous-vs-synchronous-execution-what-does-it-really-mean