
## Send Message

```
objc_msgSend
    Sends a message with a simple return value to an instance of a class.
objc_msgSend_fpret
    Sends a message with a floating-point return value to an instance of a class.
objc_msgSend_stret
    Sends a message with a data-structure return value to an instance of a class.
objc_msgSendSuper
    Sends a message with a simple return value to the superclass of an instance of a class.
objc_msgSendSuper_stret
    Sends a message with a data-structure return value to the superclass of an instance of a class.
```

## 使用 

``` java
@implementation Person
- (void)sayHello {
    NSLog(@"=== sayHello");
}
- (void)sayGoodBye:(NSString *)name {
    NSLog(@"=== bye %@", name);
}
- (NSString *)getName {
    return @"Peter";
}
@end

// 调用
id obj = [[Person alloc] init];
((void(*)(id, SEL))objc_msgSend)(obj, NSSelectorFromString(@"sayHello"));
((void(*)(id, SEL, id))objc_msgSend)(obj, NSSelectorFromString(@"sayGoodBye:"), @"Peter");
id result = ((id(*)(id, SEL))objc_msgSend)(obj, NSSelectorFromString(@"getName"));
```

## 消息转发

分 3 个步骤：

1. 从当前类的缓存中查找 imp
2. 从方法列表查找消息，从父类递归查找
3. 消息转发

