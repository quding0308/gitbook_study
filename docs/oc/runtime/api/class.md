## runtime api

```
// 根据 superclass 创建分配新的 class，该 class 会创建分配对应的 superclass 和 meta
objc_allocateClassPair
    Creates a new class and metaclass.

// 回收 class 对应的内存空间
objc_disposeClassPair
    Destroys a class and its associated metaclass.

// 把 name: Class 键值对存储到 gdb_objc_realized_classes table 中，如果 name 已经有对应的值，则存储失败
objc_registerClassPair
    Registers a class that was allocated using objc_allocateClassPair.
objc_duplicateClass
    Used by Foundation's Key-Value Observing.
```

Instantiating Classes
```
// 创建实例
class_createInstance
    Creates an instance of a class, allocating memory for the class in the default malloc memory zone.

objc_constructInstance
    Creates an instance of a class at the specified location.
objc_destructInstance
    Destroys an instance of a class without freeing memory and removes any of its associated references.
```

## 添加 Class、实例化对象

在 runtime 阶段，会创建一个 map 存储所有的 class 。key 为 classname，value 为 Class。

```
// Maps class name to Class, for in-use classes only.
OBJC_EXPORT NXMapTable * _Nullable gdb_objc_realized_classes
```




### 源码

```
typedef struct objc_class* Class;   

typedef struct objc_object* id; 

struct objc_object {
    Class isa;
};

struct objc_class : objc_object {
    Class superclass;
    cache_t cache;
    
    /// data 返回的是 class_rw_t* 指针，class_rw_t 存储了 class 的 ivars、methods、protocols等信息
    class_data_bits_t bits;    // class_rw_t * plus custom rr/alloc flags
    class_rw_t *data() { 
        return bits.data();
    }
    void setData(class_rw_t *newData) {
        bits.setData(newData);
    }
}

```

### class_rw_t

rw 为 readwrite

```
struct class_rw_t {
    uint32_t flags;
    uint32_t version;

    const class_ro_t *ro;

    method_array_t methods;
    property_array_t properties;
    protocol_array_t protocols;

    Class firstSubclass;
    Class nextSiblingClass;

    char *demangledName;
};

```

### class_ro_t

ro 为 readonly 

```
struct class_ro_t {
    uint32_t flags;
    uint32_t instanceStart;
    uint32_t instanceSize;
    const uint8_t * ivarLayout; // <- 记录了哪些是 strong 的 ivar
    const uint8_t * weakIvarLayout; // <- 记录了哪些是 weak 的 ivar
    
    const char * name;
    method_list_t * baseMethodList;
    protocol_list_t * baseProtocols;
    const ivar_list_t * ivars;
    property_list_t *baseProperties;

    method_list_t *baseMethods() const {
        return baseMethodList;
    }
};
```
