## 编译

### 代码编译链接流程

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


### LinkMap 文件

#### 如何生成 LinkMap 文件

Build Setting 中设置 writie Link Map File 为YES，build完后在指定目录查找。

LinkMap文件包含3部分：

1.Object Files

这部分内容都是 .m文件编译后的.o文件和需要link的.a文件。签名是文件编号，后面是文件路径。

```
# Object files:
[  0] linker synthesized
[  1] /Users/hour/Library/Developer/Xcode/DerivedData/TestObjC-ehiipviorxrstxesehwsodphwccc/Build/Intermediates.noindex/TestObjC.build/Debug-iphonesimulator/TestObjC.build/TestObjC.app-Simulated.xcent
[  2] /Users/hour/Library/Developer/Xcode/DerivedData/TestObjC-ehiipviorxrstxesehwsodphwccc/Build/Intermediates.noindex/TestObjC.build/Debug-iphonesimulator/TestObjC.build/Objects-normal/x86_64/HelloWorld.o
[  3] /Users/hour/Library/Developer/Xcode/DerivedData/TestObjC-ehiipviorxrstxesehwsodphwccc/Build/Intermediates.noindex/TestObjC.build/Debug-iphonesimulator/TestObjC.build/Objects-normal/x86_64/ViewController.o
等等
[ 10] /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator12.1.sdk/System/Library/Frameworks//UIKit.framework/UIKit.tbd
```

2.Sections 

这里描述的是每个 Section 在可执行文件中的位置和大小。每个 Section 的 Segment 分为 __TEXT代码段 和 __DATA数据段 两种类型

```
# Sections:
# Address	Size    	Segment	Section
0x100001450	0x00000567	__TEXT	__text
0x1000019B8	0x0000004E	__TEXT	__stubs
0x100001A08	0x00000092	__TEXT	__stub_helper
0x100001A9A	0x000000B0	__TEXT	__cstring
0x100001B4A	0x0000004F	__TEXT	__objc_classname
0x100001B99	0x00000A2D	__TEXT	__objc_methname
0x1000025C6	0x0000086D	__TEXT	__objc_methtype
0x100002E33	0x00000178	__TEXT	__entitlements
0x100002FAC	0x00000048	__TEXT	__unwind_info
0x100003000	0x00000010	__DATA	__nl_symbol_ptr
0x100003010	0x00000018	__DATA	__got
0x100003028	0x00000068	__DATA	__la_symbol_ptr
0x100003090	0x00000030	__DATA	__const
0x1000030C0	0x00000040	__DATA	__cfstring
0x100003100	0x00000020	__DATA	__objc_classlist
0x100003120	0x00000010	__DATA	__objc_protolist
0x100003130	0x00000008	__DATA	__objc_imageinfo
0x100003138	0x00000D48	__DATA	__objc_const
0x100003E80	0x00000010	__DATA	__objc_selrefs
0x100003E90	0x00000008	__DATA	__objc_classrefs
0x100003E98	0x00000008	__DATA	__objc_superrefs
0x100003EA0	0x00000008	__DATA	__objc_ivar
0x100003EA8	0x00000140	__DATA	__objc_data
0x100003FE8	0x000000C0	__DATA	__data
```

3.Symbols 

Symbols 对 Section 进行了再划分。这里会描述所有的 methods、ivar和字符串等对应的地址、大小、文件编号信息。

```
# Symbols:
# Address	Size    	File  Name
0x100001450	0x00000027	[  2] -[HelloWorld hello]
0x100001480	0x00000040	[  3] -[ViewController viewDidLoad]
0x1000014C0	0x00000027	[  3] -[MyClass hello]
0x1000014F0	0x00000092	[  4] _main
0x100001590	0x00000080	[  5] -[AppDelegate application:didFinishLaunchingWithOptions:]
0x100001610	0x00000040	[  5] -[AppDelegate applicationWillResignActive:]
...
```




参考：
http://blog.cnbang.net/tech/2296/

http://www.cloudchou.com/android/post-992.html

https://stackoverflow.com/questions/32003262/find-size-contributed-by-each-external-library-on-ios