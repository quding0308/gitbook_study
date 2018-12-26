
### Xcode 编译流程

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