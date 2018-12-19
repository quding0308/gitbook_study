## NSMutableDictionary 与 NSDictionary 使用


### Key 与 Value 类型

a key-value paire is called an entry

在 Dictionary 中，key 是唯一的(使用 isEqual: 来比较)。

key 可以是任意对象(保证实现了 NSCopying 协议即可)

key 与 value 都不可以为 nil，但可以使用 [NSNull null]

定义类，实现NSCopying协议，该对象实例就可以作为key
``` c
@interface MyKey: NSObject <NSCopying>
@end

@implementation MyKey
- (id)copyWithZone:(NSZone *)zone {
    MyKey *copy = [[MyKey alloc] init];
    return copy;
}
@end
```

具体使用：
```
NSMutableDictionary<MyKey *, NSNumber *> *dict1 = @{}.mutableCopy;

// MyKey 作为 key，每次都会copy一个新实例作为 字典的key
MyKey *key = [[MyKey alloc] init];

// @(2) 为 NSNumber 的简写
[dict1 setObject:@(2) forKey:key];

// value 可以为 [NSNull null]
[dict1 setObject:[NSNull null] forKey:key];
[dict1 setObject:[NSNull null] forKey:key];

// key 可以使用 [NSNull null] 唯一，所以会覆盖
[dict1 setObject:@(3) forKey:[NSNull null]];
[dict1 setObject:@(4) forKey:[NSNull null]];

注意 - (void)setValue:(nullable id)value forKey:(NSString *)key;  中的key为 NSString
[dict1 setValue:[NSNumber numberWithInt:1] forKey: key];

打印结果：
(lldb) po dict1
{
    "<MyKey: 0x60800001f2c0>" = 1;
    "<MyKey: 0x60800001f2e0>" = "<null>";
    "<MyKey: 0x60800001f1e0>" = "<null>";
    "<null>" = 4;
    "<MyKey: 0x60800001f2d0>" = 2;
}

```

### 桥接


通过 __bridge 桥接 Core Foundation 与 Cocoa 中对应的类
```
NSString *str = (__bridge NSString *)strRef;

NSString *hello = @"hello";
CFStringRef helloRef = (__bridge CFStringRef)hello;
```

CFDictionaryRef
```
NSDictionary is “toll-free bridged” with its Core Foundation counterpart, CFDictionaryRef. 
typedef struct __CFDictionary *CFDictionaryRef;

CFStringRef keys[3];
keys[0] = CFSTR("key1");
keys[1] = CFSTR("key2");
keys[2] = CFSTR("key3");

CFStringRef values[3];
values[0] = CFSTR("values1");
values[1] = CFSTR("values2");
values[2] = CFSTR("values3");

/// immutable
CFDictionaryRef dictRef = CFDictionaryCreate(kCFAllocatorDefault, (void *)keys, (void *)values, 3, NULL, NULL);
CFIndex count = CFDictionaryGetCount(dictRef);
// copy
CFDictionaryRef dict1Ref = CFDictionaryCreateCopy(kCFAllocatorDefault, dictRef);

// ...

CFRelease(dictRef);
CFRelease(dict1Ref);
```

CFMutableDictionaryRef
```
/// mutable 个数为0 表示不限制个数
CFMutableDictionaryRef mDictRef = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, NULL, NULL);

// add
CFDictionaryAddValue(mDictRef, CFSTR("key0"), CFSTR("value0"));

const void * value = CFDictionaryGetValue(mDictRef, CFSTR("key0"));

// 使用完释放
CFRelease(mDictRef);
```

CFStringRef 与 CFMutableStringRef
```
CFStringRef strRef = CFSTR("你好");

// 0 为 没有大小限制
CFMutableStringRef mStrRef = CFStringCreateMutable(kCFAllocatorDefault, 0);

CFStringAppend(mStrRef, strRef);
CFStringAppend(mStrRef, CFSTR("，Peter"));

CFRelease(strRef);
CFRelease(mStrRef);

```

CFArrayRef
```

```


### 参考

- 官方文档：https://developer.apple.com/documentation/foundation/nsdictionary?language=objc
- 