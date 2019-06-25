
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
// 遍历查找父类 method
Method class_getInstanceMethod(Class cls, SEL name);
Method class_getClassMethod(Class cls, SEL name);

// 返回当前 class 内存储的 methods  (cls->data()->methods)
Method  _Nonnull * class_copyMethodList(Class cls, unsigned int *outCount);

BOOL class_addMethod(Class cls, SEL name, IMP imp, const char *types);
IMP class_replaceMethod(Class cls, SEL name, IMP imp, const char *types);

IMP class_getMethodImplementation(Class cls, SEL name);
IMP class_getMethodImplementation_stret(Class cls, SEL name);
```

### 源码实现

### get method
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

### add & replace method
```
BOOL class_addMethod(Class cls, SEL name, IMP imp, const char *types)
{
    if (!cls) return NO;

    rwlock_writer_t lock(runtimeLock);
    return ! addMethod(cls, name, imp, types ?: "", NO);
}

IMP class_replaceMethod(Class cls, SEL name, IMP imp, const char *types)
{
    if (!cls) return nil;

    rwlock_writer_t lock(runtimeLock);
    return addMethod(cls, name, imp, types ?: "", YES);
}

// add 和 replace 都调用了 addMethod 方法
static IMP addMethod(Class cls, SEL name, IMP imp, const char *types, bool replace)
{
    IMP result = nil;

    method_t *m;
    if ((m = getMethodNoSuper_nolock(cls, name))) {
        // method 已经存在， already exists  
        if (!replace) {
            // add 不做任何处理，返回已经存在的 imp
            result = m->imp;
        } else {
            // replace 会取出已经存在的 mehtod_t ，然后替换 imp
            result = _method_setImplementation(cls, m, imp);
        }
    } else {
        // method 还不存在，则会创建 一个 method_list_t，把 method 添加到 method_list_t 中，
        // 然后把 method_list_t 添加到 cls->data()->methods 中(class_rw_t 所有的 class_array_t 中)
        method_list_t *newlist;
        newlist = (method_list_t *)calloc(sizeof(*newlist), 1);
        newlist->entsizeAndFlags = 
            (uint32_t)sizeof(method_t) | fixed_up_method_list;
        newlist->count = 1;
        newlist->first.name = name;
        newlist->first.types = strdup(types);
        if (!ignoreSelector(name)) {
            newlist->first.imp = imp;
        } else {
            newlist->first.imp = (IMP)&_objc_ignored_method;
        }

        prepareMethodLists(cls, &newlist, 1, NO, NO);
        // attachLists 会添加到 methods 的最前面，所以每次顺序从 method_array_t 中取 method_t 时，都会优先取出后添加的 method_t 。(这里解释了 category 添加的方法会优先于 class 的方法调用)
        cls->data()->methods.attachLists(&newlist, 1);
        flushCaches(cls);

        result = nil;
    }

    return result;
}
```
