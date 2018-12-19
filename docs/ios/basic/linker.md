## 链接

Linker链接器 

目标文件纯粹是字节块的集合。这些块中包含程序代码、程序数据，也包含引导Linker和Loader数据结构。
Linker将这些字节块连接起来，确定被连接块的运行时位置，并且修改代码和数据块中的各种位置。

Linker有两个作用：
1. 符号解析(symbol resolution)。符号解析的目的是 将每个符号引用 和 一个符号定义正好联系起来。
2. 重定位(relocation)。编译器和汇编器生成从地址0开始的代码和数据节。链接器通过把每个符号定义和一个内存位置关联起来，从而成功定位这些节，然后修改所有对这些符号的引用，使得他们指向这个内存位置。

Link Binary To Libraries

.a  are static library ，会被编译成程序的一部分；
.dylib are dynamic library ，不会编译到程序中，link的时候会dynamically linked
.framework 在link的时候会dynamically linked

http://stackoverflow.com/questions/6245761/difference-between-framework-and-static-library-in-xcode4-and-how-to-call-them

https://discussions.apple.com/thread/1895619?start=0&tstart=0

制作.a 文件：
http://blog.csdn.net/pjk1129/article/details/7255163

framework学习很好的文章：
http://gaobusi.iteye.com/blog/1684415

Mach-O 可执行文件

动态库 和 静态库的各自特点

通过写代码体验 静态库 和 动态库的区别

iOS中使用 动态库 和 静态库

动态库和静态库的格式

.a 格式为 "ar archive"，为静态库。Xcode创建项目时可选。使用.a文件，注意需要手动导入 头文件和bundle。
关于Framework的使用

1. 动态库 和 静态库 都可以是Framework

系统的.framework是动态库，CocoaPods现在项目中默认是动态库。用Xcode创建Framework的时候默认是动态库，可以修改Build Settings的Mach-O Type为Static Library，使Framework为静态库。
2. 什么是Framework

Framework是一个Cocoa程序中一种资源打包方式，可以把代码、头文件、资源文件打包为一个Framework文件，方便开发使用。 

静态Framework无法读取资源文件？
framework中资源读取问题: 

动态库就是一个Bundle，指定为当前Bundle就可以读取图片等相关资源 

'' // bundle参数如果不传，默认是mainBundle。 

'' NSBundle *bundle = [NSBundle bundleForClass:self.class]; 

'' UIImage *img = [UIImage imageNamed:@"live_placeHolder_headerImg" inBundle:bundle compatibleWithTraitCollection:nil]; 

'' 注意:在主程序中读framework里面的资源文件也如上
静态库，代码会编译进可执行文件中。需要生成一个对应Bundle，copy到项目中。(CocoaPods就是这样做) 

参考：[http://www.qidiandasheng.com/2017/01/09/framework/#useframeworks]

动态库、静态库比较：
https://www.jianshu.com/p/743deabe15ae?utm_campaign=maleskine&utm_content=note&utm_medium=seo_notes&utm_source=recommendation

https://github.com/awesome-tips/iOS-Tips/blob/master/2018/07.md#objective-c-import-%E7%AC%AC%E4%B8%89%E6%96%B9%E5%BA%93%E5%A4%B4%E6%96%87%E4%BB%B6%E6%80%BB%E7%BB%93

代码和资源的打包在一起
dynamic framework
    私有的动态库，只能放在自己的沙盒内。主app和插件extension可共用

static framework

dylib 介绍：https://www.mikeash.com/pyblog/friday-qa-2012-11-09-dyld-dynamic-linking-on-os-x.html

### 相关概念



### 相关工具


