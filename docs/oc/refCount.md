
ARC的引用计数的存储有3种方式
- TaggedPointer
- isa指针
- 散列表

### TaggedPointer
TaggedPointer专门用来存储小的对象（例如 NSNumber、NSDate、小字符串），TaggedPointer指针的地址不再仅仅是地址了，而是存储了真正的值。它的内存并不存储在堆中，也不需要调用malloc 和 free。

在64位机器上，并且是iPhone平台支持TaggedPointer

官方描述：objc-runtime-new.mm中
```
/***********************************************************************
* Tagged pointer objects.
*
* Tagged pointer objects store the class and the object value in the 
* object pointer; the "pointer" does not actually point to anything.
* 
* Tagged pointer objects currently use this representation:
* (LSB) // 最低有效位 Least Significant Bit
*  1 bit   set if tagged, clear if ordinary object pointer
*  3 bits  tag index
* 60 bits  payload
* (MSB) // 最高有效位 Most Significant Bit
* The tag index defines the object's class. 
* The payload format is defined by the object's class.
*
* This representation is subject to change. Representation-agnostic SPI is:
* objc-internal.h for class implementers.
* objc-gdb.h for debuggers.
**********************************************************************/
```
由于不需要再堆中存储，也不需要内存管理。所以在内存管理中 retain和release都不追做任何操作。retainCount会返回自己的地址。
```
id objc_retain(id obj) {
    if (obj->isTaggedPointer()) return obj;
}

void objc_release(id obj) {
    if (obj->isTaggedPointer()) return;
}

inline uintptr_t objc_object::rootRetainCount() {
    if (isTaggedPointer()) return (uintptr_t)this;
}
```
对于TaggedPointer对象，weak引用也不需要做额外管理（不需要再全局hash表中做记录）
```
id weak_register_no_lock(weak_table_t *weak_table, id referent_id,
                    id *referrer_id, bool crashIfDeallocating)
{
    objc_object *referent = (objc_object *)referent_id;
    objc_object **referrer = (objc_object **)referrer_id;
    if (!referent  ||  referent->isTaggedPointer()) return referent_id;
}

id weak_read_no_lock(weak_table_t *weak_table, id *referrer_id)
{
    objc_object **referrer = (objc_object **)referrer_id;
    objc_object *referent = *referrer;
    if (referent->isTaggedPointer()) return (id)referent;
}
```
### is-a指针存储引用计数
用 64 bit 存储一个内存地址显然是种浪费，毕竟很少有那么大内存的设备。于是可以优化存储方案，用一部分额外空间存储其他内容。isa 指针第一位为 1 即表示使用优化的 isa 指针。

在 64 位环境下，优化的 isa 指针并不是就一定会存储引用计数，毕竟用 19bit （iOS 系统）保存引用计数不一定够。需要注意的是这 19 位保存的是引用计数的值减一。has_sidetable_rc 的值如果为 1，那么引用计数会存储在一个叫 SideTable 的类的属性中，后面会详细讲。

只有在64位的真机上才会使用下面的结构体：
```
union isa_t
{
    isa_t() { }
    isa_t(uintptr_t value) : bits(value) { }
    
    Class cls;
    uintptr_t bits;
    
    // extra_rc must be the MSB-most field (so it matches carry/overflow flags)
    // indexed must be the LSB (fixme or get rid of it)
    // shiftcls must occupy the same bits that a real class pointer would
    // bits + RC_ONE is equivalent to extra_rc + 1
    // RC_HALF is the high bit of extra_rc (i.e. half of its range)
    
    // future expansion:
    // uintptr_t fast_rr : 1;     // no r/r overrides
    // uintptr_t lock : 2;        // lock for atomic property, @synch
    // uintptr_t extraBytes : 1;  // allocated with extra bytes
    
#   define ISA_MASK        0x0000000ffffffff8ULL
#   define ISA_MAGIC_MASK  0x000003f000000001ULL
#   define ISA_MAGIC_VALUE 0x000001a000000001ULL
    struct {
// 0表示普通isa指针，1表示使用优化，存储引用计数
        uintptr_t indexed           : 1;
// 是否包含associated object
        uintptr_t has_assoc         : 1;
// 
        uintptr_t has_cxx_dtor      : 1;
// 类的指针
        uintptr_t shiftcls          : 33; // MACH_VM_MAX_ADDRESS 0x1000000000
// unknow
        uintptr_t magic             : 6;
// 是否有weak对象
        uintptr_t weakly_referenced : 1;
// 是否在析构
        uintptr_t deallocating      : 1;
// 引用计数值过大，还需要存储在sidetable中
        uintptr_t has_sidetable_rc  : 1;
// 存储引用计数值减1后的结果
        uintptr_t extra_rc          : 19;
#       define RC_ONE   (1ULL<<45)
#       define RC_HALF  (1ULL<<18)
    };
};
```

使用is-a指针记录引用计数时的源码 （代码有修改，源码在NSObject.mm中找）
```
id objc_object::rootRetain(bool tryRetain, bool handleOverflow) {
    isa_t oldisa;
    isa_t newisa;
    
    transcribeToSideTable = false;
    oldisa = LoadExclusive(&isa.bits);
    newisa = oldisa;
    if (newisa.indexed) {
        uintptr_t carry;
        newisa.bits = addc(newisa.bits, RC_ONE, 0, &carry);  // 给extra_rc++
        
        // extra_rc 无法储存了，
        if (carry) {
            // newisa.extra_rc++ overflowed
            if (!handleOverflow) return rootRetain_overflow(tryRetain);
            // Leave half of the retain counts inline and
            // prepare to copy the other half to the side table.
            if (!tryRetain && !sideTableLocked) sidetable_lock();
            sideTableLocked = true;
            transcribeToSideTable = true;
            newisa.extra_rc = RC_HALF;
            newisa.has_sidetable_rc = true;
            
            // Copy the other half of the retain counts to the side table.
            sidetable_addExtraRC_nolock(RC_HALF);
            
            if (!tryRetain && sideTableLocked) sidetable_unlock();
            return (id)this;
        }
    }
}

inline uintptr_t objc_object::rootRetainCount()
{
    sidetable_lock();
    isa_t bits = LoadExclusive(&isa.bits);
    if (bits.indexed) {
        uintptr_t rc = 1 + bits.extra_rc;
        if (bits.has_sidetable_rc) {     // 引用计数值过大，还需要存储在sidetable中
            rc += sidetable_getExtraRC_nolock();
        }
        sidetable_unlock();
        return rc;
    }
}
```

### 散列表存储引用计数
散列表来存储引用计数具体是用 DenseMap 类来实现
```
typedef objc::DenseMap<DisguisedPtr<objc_object>,size_t,true> RefcountMap;

key 键的类型为 DisguisedPtr<objc_object>，DisguisedPtr 类是对 objc_object * 指针及其一些操作进行的封装，其内容可以理解为对象的内存地址

value 值的类型为 unsigned long。这里保存的值也是等于引用计数减一

更详细 在 weak 那一篇文章中

```


### 参考

- http://yulingtianxia.com/blog/2015/12/06/The-Principle-of-Refenrence-Counting/