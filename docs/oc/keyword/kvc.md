
### 简介

```
Key-value coding is a mechanism enabled by the NSKeyValueCoding informal protocol that objects adopt to provide indirect access to their properties. When an object is key-value coding compliant, its properties are addressable via string parameters through a concise, uniform messaging interface. This indirect access mechanism supplements the direct access afforded by instance variables and their associated accessor methods.
```

```
键值编码是由 NSKeyValueCoding 非正式协议启用的机制，对象采用该机制提供对其属性的间接访问。 当对象符合键值编码时，其属性可通过字符串参数通过简洁，统一的消息传递接口寻址。 这种间接访问机制补充了实例变量及其相关访问器方法提供的直接访问。
```

### valueForKey 取值顺序

```

@interface RuntimeTest3 () {
    NSString *name;
     NSString *_name;
}


@end

@implementation RuntimeTest3

- (instancetype)init
{
    self = [super init];
    if (self) {
        name = @"name";
        _name = @"_name";
    }
    return self;
}

// 创建一个新的 class 并 初始化一个实例
+ (void)test {
    RuntimeTest3 *test3 = [[RuntimeTest3 alloc] init];
    
    NSString *name = [test3 valueForKey:@"name"];
    
    /**
     获取值的顺序为：
        getName_method
        name_method
        isName_method
        _getName_method
        _name_method
        _name
        name
     */
    
    NSLog(@"");
}

- (NSString *)getName {
    return @"getName_method";
}

- (NSString *)name {
    return @"name_method";
}

- (NSString *)isName {
    return @"isName_method";
}

- (NSString *)_getName {
    return @"_getName_method";
}

- (NSString *)_name {
    return @"_name_method";
}

- (NSString *)_isName {
    return @"_isName_method";
}
@end

```

### 参考

- https://juejin.im/post/5ca0d54d6fb9a05e1d26b35b
