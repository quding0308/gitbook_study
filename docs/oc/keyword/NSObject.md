## NSObject

### Protocol NSObject

```
@protocol NSObject

/// 发消息
- (id)performSelector:(SEL)aSelector;
- (id)performSelector:(SEL)aSelector withObject:(id)object;
- (id)performSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2;

- (BOOL)respondsToSelector:(SEL)aSelector;

/// 是否为 Cls 类型，也可以为子类
- (BOOL)isKindOfClass:(Class)aClass;
/// 是否为 Cls 类型，
- (BOOL)isMemberOfClass:(Class)aClass;
- (BOOL)conformsToProtocol:(Protocol *)aProtocol;

/// what？
- (BOOL)isProxy;

- (BOOL)isEqual:(id)object;

@property (readonly) NSUInteger hash;

@property (readonly) Class superclass;
- (Class)class;
- (instancetype)self;

@end
```

### Class NSObject

```

@interface NSObject <NSObject> {
    Class isa;
}

+ (void)load;
+ (void)initialize;

+ (instancetype)new;
+ (instancetype)alloc;
/// zone 的作用
+ (instancetype)allocWithZone:(NSZone)zone;

- (void)init;
- (void)dealloc

- (id)copy;
- (id)mutableCopy;

+ (BOOL)isSubclassOfClass:(Class)aClass;
+ (BOOL)instancesRespondToSelector:(SEL)aSelector;
+ (BOOL)conformsToProtocol:(Protocol *)protocol;
- (IMP)methodForSelector:(SEL)aSelector;
+ (IMP)instanceMethodForSelector:(SEL)aSelector;
- (void)doesNotRecognizeSelector:(SEL)aSelector;

// 动态增加 IMP
+ (BOOL)resolveClassMethod:(SEL)sel __OSX_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_2_0);
+ (BOOL)resolveInstanceMethod:(SEL)sel __OSX_AVAILABLE_STARTING(__MAC_10_5, __IPHONE_2_0);

// 消息转发
- (id)forwardingTargetForSelector:(SEL)aSelector;
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector;
- (void)forwardInvocation:(NSInvocation *)anInvocation;
```

### 注意事项：




