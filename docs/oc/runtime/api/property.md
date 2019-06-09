## 概要

```
// property_t 等价于 
typedef struct property_t *objc_property_t;

struct property_t {
    const char *name;
    const char *attributes;
};

struct objc_property_attribute_t {
    const char *name;           /**< The name of the attribute */
    const char *value;          /**< The value of the attribute (usually empty) */
};

// 顺序存储 [property_t, property_t]
struct property_list_t : entsize_list_tt<property_t, property_list_t, 0> {
};

// 二维数组存储 [[property_t], [property_t, property_t]]
class property_array_t : public list_array_tt<property_t, property_list_t> {
};

// 注意：property_t 存储在 class_rw_t 中，跟 class_ro_t 没有关系
struct class_rw_t {
    // ...
    property_array_t properties;
    // ...
};
```

## runtime api
```
const char * property_getName(objc_property_t property);

// 示例: T@"NSString",&,N,V_lastName
const char * property_getAttributes(objc_property_t property);

char * property_copyAttributeValue(objc_property_t property, const char *attributeName);

objc_property_attribute_t * property_copyAttributeList(objc_property_t property, unsigned int *outCount);
```

## class runtime api
```
objc_property_t class_getProperty(Class cls, const char *name);

objc_property_t  _Nonnull * class_copyPropertyList(Class cls, unsigned int *outCount);

BOOL class_addProperty(Class cls, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount);

void class_replaceProperty(Class cls, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount);
```

## 源码解析

### get property
```
objc_property_t class_getProperty(Class cls, const char *name)
{
    if (!cls  ||  !name) return nil;
    rwlock_reader_t lock(runtimeLock);

    // 递归循环，从 class_rw_t 持有的 property_array_t 中遍历查找 property_t
    for ( ; cls; cls = cls->superclass) {
        for (auto& prop : cls->data()->properties) {
            if (0 == strcmp(name, prop.name)) {
                return (objc_property_t)&prop;
            }
        }
    }
    
    return nil;
}
```

### add & replace property
```
BOOL class_addProperty(Class cls, const char *name, 
                  const objc_property_attribute_t *attrs, unsigned int n)
{
    return _class_addProperty(cls, name, attrs, n, NO);
}

void class_replaceProperty(Class cls, const char *name, 
                      const objc_property_attribute_t *attrs, unsigned int n)
{
    _class_addProperty(cls, name, attrs, n, YES);
}

// add 和 replace 都会调用这里
static bool _class_addProperty(Class cls, const char *name, 
                   const objc_property_attribute_t *attrs, unsigned int count, 
                   bool replace)
{
    if (!cls) return NO;
    if (!name) return NO;

    property_t *prop = class_getProperty(cls, name);
    if (prop  &&  !replace) {
        // 如果已存在，则 add 会失败 already exists, refuse to add
        return NO;
    } 
    else if (prop) {
        // 如果已存在，则会 replace 掉 property_t 的 attris   replace existing
        rwlock_writer_t lock(runtimeLock);
        try_free(prop->attributes);
        prop->attributes = copyPropertyAttributeString(attrs, count);
        return YES;
    }
    else {
        rwlock_writer_t lock(runtimeLock);
        
        assert(cls->isRealized());
        
        // 不存在，则创建一个新的 property_list_t， 把 property_t 添加到 property_list_t，
        // 然后把 property_list_t，添加到 property_array_t 的最前端
        property_list_t *proplist = (property_list_t *)
            malloc(sizeof(*proplist));
        proplist->count = 1;
        proplist->entsizeAndFlags = sizeof(proplist->first);
        proplist->first.name = strdup(name);
        proplist->first.attributes = copyPropertyAttributeString(attrs, count);
        
        cls->data()->properties.attachLists(&proplist, 1);
        
        return YES;
    }
}
```

## 何时会加载 property
### ObjC setup
```
void _objc_init(void)  
└──const char *map_2_images(...)
    └──const char *map_images_nolock(...)
        └──void _read_images(header_info **hList, uint32_t hCount)

void _read_images(header_info **hList, uint32_t hCount)
{
    // ...
    header_info *hi;

    if (!noClassesRemapped()) {
        // 遍历所有 image ，读取其中的 class
        for (EACH_HEADER) {
            // 对应 image 中的 "__objc_classrefs" 部分 
            Class *classrefs = _getObjc2ClassRefs(hi, &count);
            for (i = 0; i < count; i++) {
                remapClassRef(&classrefs[i]);
            }

            // 对应 image 中的 "__objc_superrefs" 部分
            classrefs = _getObjc2SuperRefs(hi, &count);
            for (i = 0; i < count; i++) {
                remapClassRef(&classrefs[i]);
            }
        }
    }
    // ...
}

```
