
## 概要

```
typedef struct method_t *Method;

struct method_t {
    SEL name;
    const char *types;
    IMP imp;
};
```

objc_class 中的 method 存储在 class_rw_t 中的 method_array_t 中，也包括了 catertoy 添加的 method_t 和 运行时中增加的 method_t。

``` c
struct class_rw_t {
    const class_ro_t *ro;
    method_array_t methods;
}

// method_array_t 是存储 method_t 的容器
class method_array_t :  public list_array_tt<method_t, method_list_t> 
{
    //
}
```

class_ro_t 中有一个属性 baseMethodList 存储的是 class 最开定义的 method_t

```
struct class_ro_t {
    method_list_t * baseMethodList;
};
```



## runtime api

### Method
```
id method_invoke(id receiver, Method m, ...);
void method_invoke_stret(id receiver, Method m, ...);

SEL method_getName(Method m);
IMP method_getImplementation(Method m);
const char * method_getTypeEncoding(Method m);

IMP method_setImplementation(Method m, IMP imp);
void method_exchangeImplementations(Method m1, Method m2);


char * method_copyReturnType(Method m);
char * method_copyArgumentType(Method m, unsigned int index);

void method_getReturnType(Method m, char *dst, size_t dst_len);
void method_getArgumentType(Method m, unsigned int index, char *dst, size_t dst_len);

struct objc_method_description * method_getDescription(Method m);

```

### class

```
BOOL class_addMethod(Class cls, SEL name, IMP imp, const char *types);

Method class_getInstanceMethod(Class cls, SEL name);
Method class_getClassMethod(Class cls, SEL name);

Method  _Nonnull * class_copyMethodList(Class cls, unsigned int *outCount);

IMP class_replaceMethod(Class cls, SEL name, IMP imp, const char *types);

IMP class_getMethodImplementation(Class cls, SEL name);
IMP class_getMethodImplementation_stret(Class cls, SEL name);

```

## 源码实现

```
Method class_getClassMethod(Class cls, SEL sel)
{
    if (!cls  ||  !sel) return nil;
    return class_getInstanceMethod(cls->getMeta(), sel);
}

Method class_getInstanceMethod(Class cls, SEL sel)
{
    if (!cls  ||  !sel) return nil;
    return _class_getMethod(cls, sel);
}

static Method _class_getMethod(Class cls, SEL sel)
{
    rwlock_reader_t lock(runtimeLock);
    return getMethod_nolock(cls, sel);
}



```