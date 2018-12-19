## 编译

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
Build Setting 中设置 writie Link Map File 为YES，build完后在 
LinkMap文件包含3部分：
1. Object Files  列出了所有的代码文件列表，包括自己的代码和第三方库。
2. Sections 
3. Symbols 

参考：
http://blog.cnbang.net/tech/2296/

http://www.cloudchou.com/android/post-992.html

https://stackoverflow.com/questions/32003262/find-size-contributed-by-each-external-library-on-ios