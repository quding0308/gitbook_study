
## 概要

```
typedef struct ivar_t *Ivar;

struct ivar_t {
    int32_t *offset;
    const char *name;
    const char *type;
};

struct class_ro_t {
    // ...
    const ivar_list_t * ivars;
    // ...
};

```

### offset 

指当前 ivar 的内存起始地址

对齐规则：
- 起始地址是长度的整数倍
- 64位，struct 长度是8的倍数。32位，struct 长度是4的倍数

```
@interface RuntimeTest3 () {
    int8_t age1;
    NSString *firstName;
    int32_t age;
    NSString *lastName;
}

/*
 NSString *firstName;
 NSString *lastName;
 int32_t age;
 int8_t age1;
 
 对齐策略为：
 0--------
 isa
 8--------
 firstName
 16--------
 lastName
 24--------
 age
 28--------
 age1
 
 实例大小为 32 bytes
 */

/*
 int8_t age1;
 NSString *firstName;
 NSString *lastName;
 int32_t age;
 
 对齐策略为：
 0--------
 isa
 8--------
 age1      (这里要对齐 btyes)
 16--------
 firstName
 24--------
 lastName
 32--------
 age
 
 实例大小为 40 bytes
 */

/*
 int8_t age1;
 NSString *firstName;
 int32_t age;
 NSString *lastName;

 对齐策略为：
 0--------
 isa
 8--------
 age1      (这里要对齐 btyes)
 16--------
 firstName
 24--------
 age
 32--------
 lastName
 
 实例大小为 40 bytes
 */

/*
 int8_t age1;
 int32_t age;
 NSString *firstName;
 NSString *lastName;
 
 对齐策略为：
 0--------
 isa
 8--------
 age1
 12--------
 age
 16--------
 firstName
 24--------
 lastName
 
 实例大小为 32 bytes
 */
```

### 存储

objc_class->data() 会返回 class_rw_t。 class_rw_t->ro 持有 class_ro_t。class_ro_t 中持有 ivars 用于保存 class 的 Ivar。

```
objc_class
    ->data()  // class_rw_t。
    ->ro()    // class_ro_t。class_ro_t
    ->ivars   // const ivar_list_t* ivars  
```

ivar_list_t 继承自 entsize_list_tt， entsize_list_tt 可以理解为一个容器，拥有自己的迭代器用于遍历所有元素。 Element 表示元素类型，List 用于指定容器类型，最后一个参数为标记位。

``` c
// ivar_list_t 是存储 ivar_t 的容器
struct ivar_list_t : entsize_list_tt<ivar_t, ivar_list_t, 0> {
};

struct entsize_list_tt {  
    uint32_t entsizeAndFlags;
    uint32_t count;
    Element first;
};
```

## runtime api

### ivar 
```
const char * ivar_getName(Ivar v);

ptrdiff_t ivar_getOffset(Ivar v);

const char * ivar_getTypeEncoding(Ivar v);

```

#### 源码实现

```
// name
const char* ivar_getName(Ivar ivar)
{
    if (!ivar) return nil;
    return ivar->name;
}

// ptrdiff_t 类型变量通常用来保存两个指针减法操作的结果。
// ptrdiff_t 是 C/C++ 标准库中定义的一个与机器相关的数据类型。size_t 类型用于指明数组长度,它必须是一个正数; ptrdiff_t 类型则应保证足以存放同一数组中两个指针之间的差距，它有可能是负数
ptrdiff_t ivar_getOffset(Ivar ivar)
{
    if (!ivar) return 0;
    return *ivar->offset;
}

const char* ivar_getTypeEncoding(Ivar ivar)
{
    if (!ivar) return nil;
    return ivar->type;
}
```

### class api

```
// 首先会遍历自己，然后查找父类 直到找到
Ivar class_getClassVariable(Class cls, const char *name);
Ivar class_getInstanceVariable(Class cls, const char *name);


// class_addIvar 只能在 objc_allocateClassPair 和 objc_registerClassPair 之间调用。
// 已经存在的类不支持添加 ivar。
BOOL class_addIvar(Class cls, const char *name, size_t size, uint8_t alignment, const char *types);

// 只会遍历当前类的 var ，不会去父类查找
Ivar  _Nonnull * class_copyIvarList(Class cls, unsigned int *outCount);

const uint8_t * class_getIvarLayout(Class cls);
void class_setIvarLayout(Class cls, const uint8_t *layout);

const uint8_t * class_getWeakIvarLayout(Class cls);
void class_setWeakIvarLayout(Class cls, const uint8_t *layout);
```

#### 源码实现 

##### get variable 的实现

``` c
// 获取 class 的 ivar 相当于是 metaclass 的 instance ivar
Ivar class_getClassVariable(Class cls, const char *name)
{
    if (!cls) return nil;

    return class_getInstanceVariable(cls->ISA(), name);
}

// 获取 instance 的 ivar
Ivar class_getInstanceVariable(Class cls, const char *name)
{
    if (!cls  ||  !name) return nil;

    return _class_getVariable(cls, name, nil);
}

Ivar _class_getVariable(Class cls, const char *name, Class *memberOf)
{
    rwlock_reader_t lock(runtimeLock);

    // 递归遍历 类的继承
    for ( ; cls; cls = cls->superclass) {
        ivar_t *ivar = getIvar(cls, name);
        if (ivar) {
            if (memberOf) *memberOf = cls;
            return ivar;
        }
    }

    return nil;
}

static ivar_t *getIvar(Class cls, const char *name)
{
    runtimeLock.assertLocked();

    const ivar_list_t *ivars;
    assert(cls->isRealized());
    if ((ivars = cls->data()->ro->ivars)) {
        for (auto& ivar : *ivars) {
            if (!ivar.offset) continue;  // anonymous bitfield

            // 根据 name 来比较
            // ivar.name may be nil for anonymous bitfields etc.
            if (ivar.name  &&  0 == strcmp(name, ivar.name)) {
                return &ivar;
            }
        }
    }

    return nil;
}
```


##### add variable

class_addIvar 只能在 objc_allocateClassPair 和 objc_registerClassPair 之间调用，已经存在的类不支持添加 ivar。所以 ivar 存储在 class_ro_t 。

``` c
//

```

### object api

```
void object_setIvar(id obj, Ivar ivar, id value);
id object_getIvar(id obj, Ivar ivar);

Ivar object_setInstanceVariable(id obj, const char *name, void *value);
Ivar object_getInstanceVariable(id obj, const char *name, void * _Nullable *outValue);

```

#### 源码实现

```
// 实际调用了 object_setIvar
Ivar object_setInstanceVariable(id obj, const char *name, void *value)
{
    Ivar ivar = nil;

    if (obj  &&  name  &&  !obj->isTaggedPointer()) {
        if ((ivar = class_getInstanceVariable(obj->ISA(), name))) {
            object_setIvar(obj, ivar, (id)value);
        }
    }
    return ivar;
}

// 实际调用了 object_getIvar
Ivar object_getInstanceVariable(id obj, const char *name, void **value)
{
    if (obj  &&  name  &&  !obj->isTaggedPointer()) {
        Ivar ivar;
        if ((ivar = class_getInstanceVariable(obj->ISA(), name))) {
            if (value) *value = (void *)object_getIvar(obj, ivar);
            return ivar;
        }
    }
    if (value) *value = nil;
    return nil;
}

// 读取 ivar 的 value
id object_getIvar(id obj, Ivar ivar)
{
    if (obj  &&  ivar  &&  !obj->isTaggedPointer()) {
        Class cls = obj->ISA();
        ptrdiff_t ivar_offset = ivar_getOffset(ivar);
        if (_class_usesAutomaticRetainRelease(cls)) {
            // arc 中的 weak var 需要从 
            // for ARR, layout strings are relative to the instance start.
            uint32_t instanceStart = _class_getInstanceStart(cls);
            const uint8_t *weak_layout = class_getWeakIvarLayout(cls);
            if (weak_layout && is_scanned_offset(ivar_offset - instanceStart, weak_layout)) {
                // use the weak system to read this variable.
                id *location = (id *)((char *)obj + ivar_offset);
                return objc_loadWeak(location);
            }
        }
        
        // mrc 或 arc中的strong 根据 起始偏移量 + offset，获取到内存地址，返回 id* 的指针
        id *idx = (id *)((char *)obj + ivar_offset);
        return *idx;
    }
    return nil;
}

// 给 ivar 赋值
void object_setIvar(id obj, Ivar ivar, id value)
{
    if (obj  &&  ivar  &&  !obj->isTaggedPointer()) {
        Class cls = _ivar_getClass(obj->ISA(), ivar);
        ptrdiff_t ivar_offset = ivar_getOffset(ivar);
        id *location = (id *)((char *)obj + ivar_offset);
        // if this ivar is a member of an ARR compiled class, then issue the correct barrier according to the layout.
        if (_class_usesAutomaticRetainRelease(cls)) {
            // for ARR, layout strings are relative to the instance start.
            uint32_t instanceStart = _class_getInstanceStart(cls);
            
            // weak 赋值
            const uint8_t *weak_layout = class_getWeakIvarLayout(cls);
            if (weak_layout && is_scanned_offset(ivar_offset - instanceStart, weak_layout)) {
                // use the weak system to write to this variable.
                objc_storeWeak(location, value);
                return;
            }
            
            // strong 赋值，本质也是 *location = value;
            const uint8_t *strong_layout = class_getIvarLayout(cls);
            if (strong_layout && is_scanned_offset(ivar_offset - instanceStart, strong_layout)) {
                objc_storeStrong(location, value);
                return;
            }
        }
        
        // mrc 直接赋值
        *location = value;
    }
}


```


#### strong 下，给 ivar 赋值

```
void objc_storeStrong(id *location, id obj)
{
    id prev = *location;
    if (obj == prev) {
        return;
    }
    objc_retain(obj);
    *location = obj;
    objc_release(prev);
}
```

#### arc 下，weak 的 取值、赋值 是特别处理的

##### get value
```
id objc_loadWeak(id *location)
{
    if (!*location) return nil;
    return objc_autorelease(objc_loadWeakRetained(location));
}

// 从 保存 weak 的 hashTable 中找到真实的值
id objc_loadWeakRetained(id *location)
{
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

```