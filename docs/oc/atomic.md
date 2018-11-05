
### 原子性 Atomic

原子性是指一个操作是不可中断的，要么全部执行成功要么全部执行失败。即使多个线程一起执行的时候，一个操作一旦开始，就不会被其他线程所干扰。

    int a = 10;  // 是原子操作。只有赋值一个操作
    int b = a;  // 不是原子操作。包含两个操作：读取a；给b赋值
    a++; // 不是原子操作，包含三个操作：读取a；进行 a + 1 操作；给a赋值 

非原子性操作，在多线程操作中是不安全的。

线程不安全就是多线程环境下，执行可能不会得到正确的结果。


### property的修饰符： atomic 与 nonatomic 

实际是 对 set 和 get 方法的调整 如果是 atomic 则使用 spinlock_t 来加锁

```
static setProperty(...) {
    if (atomic) {
        spinlock_t& slotlock = PropertyLocks[slot];
        slotlock.lock();
        oldValue = *slot;
        *slot = newValue;        
        slotlock.unlock();
    } else {
        oldValue = *slot;
        *slot = newValue;
    }
}

static id objc_getProperty(...) {
    id *slot = (id*) ((char*)self + offset);
    if (!atomic) return *slot;  // nonatomic
        
    // Atomic retain release world
    spinlock_t& slotlock = PropertyLocks[slot];
    slotlock.lock();
    id value = objc_retain(*slot);
    slotlock.unlock();
    
    return value;
}

```
