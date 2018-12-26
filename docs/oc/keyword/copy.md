
系统对象分为了两类:

- 系统的非容器类对象，如 NSString、NSMutableString、NSNumber 等。
- 系统的容器类对象，如 NSArray、NSMutableArray、NSDictionary、NSMutableDictionary 等。


1. 对于系统的非容器类对象
   1. 如果对一不可变对象(如 NSString)复制，copy 是指针复制(浅拷贝)和 mutableCopy 就是对象复制(深拷贝);
   2. 如果是对可变对象(如 NSMutableString)复制，copy 和 mutableCopy 都是深拷贝，但是 copy 返回的对象是不可变的。
2. 对于系统的容器类对象
   1. 对不可变对象(如 NSArray)进行复制，copy 是指针复制(浅拷贝)， mutableCopy 是对象复制(深拷贝), 但是不管是 copy 还是 mutableCopy, 且不论容器内对象是可变还是不可变，返回的容器内对象都是指针复制(浅拷贝)。
   2. 对可变对象(如 NSMutableArray)进行复制时，copy 和 mutableCopy 都是对象复制(深拷贝)，但是不管是 copy 还是 mutableCopy，且不论容器内对象是可变还是不可变，返回的容器内对象都是指针复制(浅拷贝)。


### 参考
- http://lincode.github.io/Copying