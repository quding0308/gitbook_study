### weak

#### 总结


1. 对于TaggedPointer对象，weak引用也不需要做额外管理（不需要再全局hash表中做记录）


### 底层存储

```
// SideTables对象，以StripedMap实现，包含64个SideTable对象
static StripedMap<SideTable> SideTables()


// SideTable 
#### SideTables/RefcountMap/weak_table_t的使用
struct SideTable {
    spinlock_t slock;   // 锁保证 atomic

    /**
    RefcountMap disguises its pointers because we 
    don't want the table to act as a root for `leaks`.
    对象具体的引用计数存储在这里
    */
    RefcountMap refcnts;

    /**
    * The global weak references table. 
    * Stores object ids as keys, and weak_entry_t structs as their values.
    */
    weak_table_t weak_table;

    void lock() { slock.lock(); }
    void unlock() { slock.unlock(); }
    bool trylock() { return slock.trylock(); }

    // Address-ordered lock discipline for a pair of side tables.

    template<bool HaveOld, bool HaveNew>
    static void lockTwo(SideTable *lock1, SideTable *lock2);
    template<bool HaveOld, bool HaveNew>
    static void unlockTwo(SideTable *lock1, SideTable *lock2);
};

struct weak_table_t {
    weak_entry_t *weak_entries; // 数组 存储了指向某个对象的所有弱引用的变量指针
    size_t    num_entries;
    uintptr_t mask;
    uintptr_t max_hash_displacement;
};

struct weak_entry_t {
    DisguisedPtr<objc_object> referent; // 某个对象的指针
    weak_referrer_t *referrers; // 数组 对这个对象的弱引用的变量地址存在这里
};


```

#### weak的实现
    id objc_initWeak(id *object, id value) {
        if (!newObj) {
            *location = nil;
            return nil;
        }

        return storeWeak<false/*old*/, true/*new*/, true/*crash*/>
            (location, (objc_object*)newObj);
    }

    id objc_loadWeak(id _Nullable *location) {
        if (!*location) return nil;
        return objc_autorelease(objc_loadWeakRetained(location));
    }

    id objc_loadWeakRetained(id *object) {

        id result;

        SideTable *table;
        
    retry:
        result = *location;
        if (!result) return nil;
        
        table = &SideTables()[result];
        
        table->lock();
        if (*location != result) {
            table->unlock();
            goto retry;
        }

        result = weak_read_no_lock(&table->weak_table, location);

        table->unlock();
        return result;
    }

    id objc_storeWeak(id _Nullable *location, id obj) {
        return storeWeak(location, (objc_object *)obj)
    }

    void objc_copyWeak(id *dest, id *src) {
        id obj = objc_loadWeakRetained(src);
        objc_initWeak(dst, obj);
        objc_release(obj);
    }

    void objc_destroyWeak(id *object) {
       objc_storeWeak(object, nil);
    }

