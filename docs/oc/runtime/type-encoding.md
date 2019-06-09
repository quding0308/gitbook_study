## Type Encodings

编译器 把每个方法的返回值和参数转换成一个字符，记录在 method_types 中

**@encode**

@encode 可以直接把类型转成 type code

```
char* buf1 = @encode(NSArray);
char* buf2 = @encode(char *);

输出：
"{NSArray=#}"
"*"
```

对于的类型：
```
c char

```


### 参考

官网地址：
https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
