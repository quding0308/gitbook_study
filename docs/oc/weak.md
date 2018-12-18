### weak

ask 
```
StripMap<SideTable>  // 64 个

SideTable {
    RefcountMap refcnts;
    weak_table_t weak_table;
}

weak_table_t {
    weak_entry_t *weak_entries;
}


```

#### 总结

1. 对于TaggedPointer对象，weak引用也不需要做额外管理（不需要再全局hash表中做记录）

### 底层存储

#### StripedMap
包含64个 sidetable 对象，根据 对象的地址 找到某个sidetable对象
```
// SideTables对象，以StripedMap实现，包含64个SideTable对象
static StripedMap<SideTable> SideTables()
```

#### SideTable
SideTable ，用于管理引用计数表(RefcountMap)和 weak 表 (weak_table_t)，并使用 spinlock_lock 自旋锁来防止操作表结构时可能的竞态条件。

SideTables/RefcountMap/weak_table_t的使用
```
struct SideTable {
    // 保存引用计数的散列表
    RefcountMap refcnts;
    //保存 weak 引用的全局散列表
    weak_table_t weak_table;
    // 保证原子操作的自选锁
    spinlock_t slock;   // 锁保证 atomic
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
```
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
```

#### strong 实现

```
//hash table   key 为obj，value 为 引用计数
typedef objc::DenseMap<DisguisedPtr<objc_object>,size_t,true> RefcountMap;
```