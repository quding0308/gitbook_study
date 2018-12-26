

#### ARC

#### Runtime Support

```
id objc_autorelease(id value);
void objc_autoreleasePoolPop(void *pool);
void *objc_autoreleasePoolPush(void);
id objc_autoreleaseReturnValue(id value);
void objc_copyWeak(id *dest, id *src);
void objc_destroyWeak(id *object);
id objc_initWeak(id *object, id value);
id objc_loadWeak(id *object);
id objc_loadWeakRetained(id *object);
void objc_moveWeak(id *dest, id *src);
void objc_release(id value);
id objc_retain(id value);
id objc_retainAutorelease(id value);
id objc_retainAutoreleaseReturnValue(id value);
id objc_retainAutoreleasedReturnValue(id value);
id objc_retainBlock(id value);
id objc_storeStrong(id *object, id value);
id objc_storeWeak(id *object, id value);
```

### 引用计数

下一篇文章


### 参考：

- https://clang.llvm.org/docs/AutomaticReferenceCounting.html#arc-optimization-precise
