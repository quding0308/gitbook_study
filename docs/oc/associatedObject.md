### AssociatedObject


#### AssociationsManager
AssociationsManager 为全局的单例  
```
class AssociationsManager {
    static spinlock_t _lock;
    static AssociationsHashMap *_map;     
}
```

#### AssociationsHashMap
```
typedef hash_map<disguised_ptr_t, ObjectAssociationMap *> AssociationsHashMap;

key 为 obj的地址

value 为 一个ObjectAssociationMap

```

#### ObjectAssociationMap

```
typedef hash_map<void *, ObjcAssociation> ObjectAssociationMap;

key 为自定义的值  例如 @selector(helloMethod)
value 为 ObjcAssociation

```

#### ObjcAssociation
```
class ObjcAssociation {
    uintptr_t _policy;
    id _value;
};
```

### 何时释放？

当对象被释放时，会调用  _object_remove_assocations(obj) 移除关联对象



### 使用
```

objc_setAssociatedObject(self, @selector(selectedView), selectView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

objc_getAssociatedObject(self, @selector(kd_selectedView));

// policy
typedef OBJC_ENUM(uintptr_t, objc_AssociationPolicy) {
    OBJC_ASSOCIATION_ASSIGN = 0,           /**< Specifies a weak reference to the associated object. */
    OBJC_ASSOCIATION_RETAIN_NONATOMIC = 1, /**< Specifies a strong reference to the associated object. 
                                            *   The association is not made atomically. */
    OBJC_ASSOCIATION_COPY_NONATOMIC = 3,   /**< Specifies that the associated object is copied. 
                                            *   The association is not made atomically. */
    OBJC_ASSOCIATION_RETAIN = 01401,       /**< Specifies a strong reference to the associated object.
                                            *   The association is made atomically. */
    OBJC_ASSOCIATION_COPY = 01403          /**< Specifies that the associated object is copied.
                                            *   The association is made atomically. */
};

```