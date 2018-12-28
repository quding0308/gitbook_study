### 程序运行

**compile time**

compiler

**link time**

linker

**load time**

程序被加载器(loader)加载到内存并执行

**run time**

由应用程序来执行


**LLVM**

LLVM是一个模块化和可重用的编译器和工具链技术的集合，Clang 是 LLVM 的子项目，是 C，C++ 和 Objective-C 编译器。

更多介绍：http://www.aosabook.org/en/llvm.html

**clang static analyzer**

主要是进行语法分析，语义分析和生成中间代码，当然这个过程会对代码进行检查，出错的和需要警告的会标注出来。

**lld** 是 Clang / LLVM 的内置链接器，clang 必须调用链接器来产生可执行文件。


**ASLR**

ASLR(address space layout randomization)，地址空间随机布局

aslr是一种针对缓冲区溢出的安全保护技术，通过对堆、栈、共享库映射等线性区布局的随机化，通过增加攻击者预测目的地址的难度，防止攻击者直接定位攻击代码位置，达到阻止溢出攻击的目的的一种技术



参考：
- https://ming1016.github.io/2017/03/01/deeply-analyse-llvm/
- ASLR：http://wiki.jikexueyuan.com/project/ios-security-defense/aslr.html