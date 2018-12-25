## 编译

https://objccn.io/issue-6-2/

https://objccn.io/issue-6-3/

https://github.com/macmade/ClangKit

https://github.com/aidansteele/osx-abi-macho-file-format-reference

**编译**

编译器会把每个 .m/.c/.mm 文件 编译成 .o 文件 (编译过程中会有 .d/.dia 中间文件生成)
MyClass.m -> MyClass.d + MyClass.dia  MyClass.o

编译完成后，linker 会链接 .o 文件，合并后生成可执行文件

举例编译 

**链接**



参考：

https://www.jianshu.com/p/9fc7776cce9b

### Xcode 工程编译流程

* 编译信息写入辅助文件，创建文件架构 .app 文件
* 处理文件打包信息
* 执行 CocoaPod 编译前脚本，checkPods Manifest.lock
* 编译.m文件，使用 CompileC 和 clang 命令
* 链接需要的 Framework
* 编译 xib
* 拷贝 xib ，资源文件
* 编译 ImageAssets
* 处理 info.plist
* 执行 CocoaPod 脚本
* 拷贝标准库
* 创建 .app 文件和签名

参考：

https://juejin.im/post/5a352bb0f265da433562d5e3

### 加快编译速度

参考：

https://juejin.im/post/59539377f265da6c415f064d

https://medium.com/swift-programming/swift-build-time-optimizations-part-2-37b0a7514cbe




### dsym文件

程序在执行时通过地址来调用函数。dsym文件中储存了函数地址映射，函数地址可以通过dsym文件映射到具体函数位置。

### 代码文件

- 可执行文件
- Object
- 静态库文件
- 动态库文件

标识 从 Mach64 Header 中可以读出 File Type

#### 可执行文件中数据

一个代码二进制文件中 包含的不同区域 成为 Segment

在运行时，虚拟内存会把segment映射到进程的地址空间，按需加载(mmap技术)

Segment 具体分为：

**__TEXT** segment

包含被执行的代码，被只读和可执行的方式映射。

- __cstring 可执行文件中的字符串
- __const 不可变的常量
- __text  包含编译后的机器码
- __stubs 和 __stub_helper 是给动态链接器 dyld 使用，可以允许延迟链接

**__DATA** segment

以可读写和不可执行的方式映射（里面的数据可以被改变）


**__LINKEDIT**


**__PAGEZERO**


### Mach-O文件

头部信息:
```
struct mach_header {
  uint32_t      magic;
  cpu_type_t    cputype;
  cpu_subtype_t cpusubtype;
  uint32_t      filetype;
  uint32_t      ncmds;
  uint32_t      sizeofcmds;
  uint32_t      flags;
};
```


### 参考：
http://blog.cnbang.net/tech/2296/

http://www.cloudchou.com/android/post-992.html

https://stackoverflow.com/questions/32003262/find-size-contributed-by-each-external-library-on-ios
