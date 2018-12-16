## Runtime 运行时api

runtime是OC底层的一套c语言API。编译器会把oc代码编译成运行时代码，调用的就是runtime接口。

两个头文件：

```
#import <objc/objc.h>
#import <objc/runtime.h>    
```

### 涉及的概念

Class

```
typedef struct objc_class *Class;   // Class是一个指向objc_class结构体的指针

struct objc_class {
    Class isa;  // meta class
    Class super_class; // 父类 或 NULL

    const char *name; // 类名
    long version; //类的版本
    long info;  // 类的信息
    long instance_size; // 对象实例大小  

    struct objc_ivar_list *ivars;// 变量
    struct objc_method_list **methodLists; // 方法
    struct objc_protocol_list *protocols; // 协议

    struct objc_cache *cache;   方法缓存
}

struct objc_ivar_list {
    int ivar_count；                         
    struct objc_ivar ivar_list[1];  // 数组
}

struct objc_method_list { 
    int method_count;                         
    struct objc_method method_list[1];  // 数组
}

struct objc_protocol_list {
    struct objc_protocol_list *next;
    long count;
    Protocol *list[1];
};

struct objc_cache {
    unsigned int mask; //指定分配缓存bucket的总数。total = mask + 1 runtime使用这个字段确定线性查找数组的索引位置
    unsigned int occupied; //实际占用缓存bucket总数
    Method buckets[1]; //指向Method数据结构指针的数组，这个数组的总数不能超过mask+1，但是指针是可能为空的，这就表示缓存bucket没有被占用，数组会随着时间增长。
};

```

id
 
```
typedef struct objc_object *id;

struct objc_object {
    Class isa;  // 指向 class
}

当向 object 发消息时，object 会根据 isa 找到 class，首先会从 class 的 objc_cache 中寻找，然后从 class 和其父类 的 methodList中寻找对应的方法运行。

```

SEL
 
选择器表示一个方法的selector的指针，可以理解为Method中的ID类型

```
typedef struct objc_selector *SEL;   标识运行时一个方法的名字（在编译阶段，根据名称生成一个唯一的整数）

获取SEL的三个方法：
    sel_registerName函数
    objectivec编译器提供的@selector()
    NSSelectorFromString()方法
```

Category

````
typedef struct objc_category *Category; // 一个category

struct objc_category {
    char *category_name                                      OBJC2_UNAVAILABLE;
    char *class_name                                         OBJC2_UNAVAILABLE;
    struct objc_method_list *instance_methods                OBJC2_UNAVAILABLE;
    struct objc_method_list *class_methods                   OBJC2_UNAVAILABLE;
    struct objc_protocol_list *protocols                     OBJC2_UNAVAILABLE;
}   
```

 IMP 函数指针
 
 ```
 typedef id(*IMP)(id, SEL, ...)
 ```
 
 Method

```
typedef struct objc_method *Method;

struct objc_method {
    SEL method_name;    // 函数名 SEL
    char *method_types; // 函数原型字符串
    IMP method_imp; // IMP 地址
}
```

Ivar

```
typedef struct objc_ivar *Ivar;    // 实例变量

struct objc_ivar {
    char *ivar_name;   // 变量名
    char *ivar_type;   // 变量类型
    int ivar_offset;   // 偏移量 根据class结构体的地址加上基地址偏移字节得到的。
}
```

objc_property_t

一个属性必然对应一个成员变量，还会根据属性修饰符，对成员变量进行一系列封装


```
typedef struct objc_property *objc_property_t;

通过class_copyPropertyList和protocol_copyPropertyList方法获取类和协议的属性

objc_property_t *class_copyPropertyList(Class cls, unsigned int *outCount)
objc_property_t *protocol_copyPropertyList(Protocol *proto, unsigned int *outCount)

struct objc_property {
    //
}

//Defines a property attribute
typedef struct {
    const char *name;  The name of the attribute
    const char *value; < The value of the attribute (usually empty)
} objc_property_attribute_t;
```

Protocol

```
typedef struct objc_object Protocol;
```

### api

Class

```

Class cls = RuntimeTest.class;

Class superCls = class_getSuperclass(cls);
BOOL isMeta =  class_isMetaClass(cls);
size_t instanceSize = class_getInstanceSize(cls);

int version = class_getVersion(cls);
class_setVersion(cls, 20);
int version1 = class_getVersion(cls);

/// === ivars
Ivar varB = class_getInstanceVariable(cls, "b");
// 添加成员变量
BOOL class_addIvar ( Class cls, const char *name, size_t size, uint8_t alignment, const char *types ); //这个只能够向在runtime时创建的类添加成员变量
// 获取整个成员变量列表
Ivar * class_copyIvarList ( Class cls, unsigned int *outCount ); //必须使用free()来释放这个数组

```

/// Methods

```
// 添加方法
BOOL class_addMethod ( Class cls, SEL name, IMP imp, const char *types ); //和成员变量不同的是可以为类动态添加方法。如果有同名会返回NO，修改的话需要使用method_setImplementation

// 获取实例方法
Method class_getInstanceMethod ( Class cls, SEL name );

// 获取类方法
Method class_getClassMethod ( Class cls, SEL name );

// 获取所有方法的数组
Method * class_copyMethodList ( Class cls, unsigned int *outCount );

// 替代方法的实现
IMP class_replaceMethod ( Class cls, SEL name, IMP imp, const char *types );

// 返回方法的具体实现
IMP class_getMethodImplementation ( Class cls, SEL name );
IMP class_getMethodImplementation_stret ( Class cls, SEL name );

// 类实例是否响应指定的selector
BOOL class_respondsToSelector ( Class cls, SEL sel );
```

objc_protocol_list
```
// 添加协议
BOOL class_addProtocol ( Class cls, Protocol *protocol );
// 返回类是否实现指定的协议
BOOL class_conformsToProtocol ( Class cls, Protocol *protocol );
// 返回类实现的协议列表
Protocol * class_copyProtocolList ( Class cls, unsigned int *outCount );
```


### 参考

- https://www.jianshu.com/p/f48ce7225cf8
- https://ming1016.github.io/2015/04/01/objc-runtime/