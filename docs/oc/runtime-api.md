## Runtime 运行时api

runtime是OC底层的一套c语言API。编译器会把oc代码编译成运行时代码，调用的就是runtime接口。

两个头文件：

```
#import <objc/objc.h>
#import <objc/runtime.h>    
```

### 涉及的概念
Class 

类

```
typedef struct objc_class *Class;   // Class是一个指向objc_class结构体的指针

struct objc_class {
    Class isa;  // meta class
    Class super_class; // 父类 或 NULL

    const char *name; // 类名
    long instance_size; // 对象实例大小  

    struct objc_ivar_list *ivars;// 变量
    struct objc_method_list **methodLists; // 方法
    struct objc_protocol_list *protocols; // 协议

    struct objc_cache *cache;   方法缓存
}
```

 id
 
 ```
typedef struct objc_object *id;

struct objc_object {
    Class isa;
}
 ```

 SEL
 
 ```
 typedef objc_selector *SEL;   标识运行时一个方法的名字（在编译阶段，根据名称生成一个唯一的整数）
 ```

Category

````
typedef struct objc_category *Category; // 一个category
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
    int ivar_offset;   // 偏移量，对成员变量寻址时使用
}
```

Property 

一个属性必然对应一个成员变量，还会根据属性修饰符，对成员变量进行一系列封装


```
objc_property_t
struct objc_property {

}
 

//Defines a property attribute
typedef struct {
    const char *name;  The name of the attribute
    const char *value; < The value of the attribute (usually empty)
} objc_property_attribute_t;
```


### 参考

- https://www.jianshu.com/p/f48ce7225cf8