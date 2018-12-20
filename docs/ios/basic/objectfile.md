## 目标文件

目标文件是字节块的集合

**目标文件有3种形式：**

1. *可重定位目标文件*。包含二进制代码和数据，可以在链接是与其他*可重定位目标文件*合并起来，创建一个*可执行目标文件*。
2. *可执行目标文件*。包含二进制代码和数据，可以被加载器(loader)加载到内存并执行
3. *共享目标文件*。一种特殊的*可重定位目标文件*，可以在程序紧挨着是被动态的加载进内存并链接。

**不同操作系统的目标文件**

第一个 Unix系统 使用 a.out 格式

现代的x86-64 Linux 和 Unix 使用 *可执行可链接格式(ELF, Executable and Linkable Format)*

Mac OS使用 Mach-O 格式

Windows 使用 PE 格式

不同系统的目标文件格式，基本概念都是相似的。

### ELF 目标文件格式

```
[   ELF头部   ]
[   .text    ]   // 代码
[   .rodata  ]   // 只读数据（常量）
[   .data    ]   // 已初始化的全局和静态c变量(局部变量被保存在栈中)
[   .bss     ]   // 未初始化的全局和静态c变量，以及被初始化为0的全局和静态变量
[  .symtab   ]   // 符号表 
[ .rel.text  ]   // text的重定位信息
[ .rel.data  ]   // data的重定位信息
[  .debug    ]   // 调试符号表(默认编译不会有这个section)
...
[   节头部表   ]

ELF头部。占16字节，描述了生成该文件的字的大小和字节顺序，目标文件累心，机器类型，节头部表的文件偏移。
节头部表(section header table) 描述了不同节的位置和大小。 
在ELF头部 和 节头部之间的都是节Section

.bss 
这个section实际没有占实际的空间，仅仅是占位符。程序运行时，再分配内存，初始值为0

.symtab
符号表(symbol table)，存放着程序中定义和引用的函数和全局变量的信息。

.rel.text 和 .rel.data 
当linker 把目标文件和其他文件组合时，需要修改这些位置。一般，对任何调用外部函数或引用全局变量的指令都需要修改。
可执行目标文件中不需要成功定位信息，因此可以省略。

```

### 符号和符号表

**符号**

每个可重定位目标块m都有一个符号表，它包含了m定义和引用的符号信息。

在链接器的上下文中，有3种不同的符号：

1. 由m定义的**全局符号**(可以被其他模块引用)。对应于非静态的c函数和全局变量
2. 由其他模块定义，并被模块m引用的全局符号。，这些符号被称为**外部符号**，对应于其他模块定义的非静态c函数和全局变量
3. 由m定义和引用的**局部符号**。对应于带static的c函数和全局变量。局部符号在模块m内可见，外部无法引用

```
在 c语言中，源文件扮演模块的角色，一个源文件就是一个模块，编译生成一个.o文件。

任何带有static修饰的全局变量或函数都是模块私有的。
```

**符号表**

.symtab section中包含ELF符号表，是一个 Elf64_Symbol 数组

```
一个 Elf64_Symbol 对应一个 符号

typedef struct {
    int name;       // 字符串表中的字节偏移 符号字符串名称以 null 结尾
    char type:4     // Function of data
        ,binding:4; // local or global 本地还是全局符号
    char reserved;  // 未使用
    short section;  // section index
    long value;     // section offset or absolute address
    long size;      // 符号大小 size in bytes
} Elf64_Symbol;

```

### 符号表解析

链接器解析符号的方法 是 把每个引用与它输入的可重定位目标文件的符号表中的一个确定符合定义关联起来。

对于 引用和定义在相同模块内的局部符号引用，符号解析很简单。

对于全局符号解析，如果 遇到了一个不在当前模块定义的符号(变量或函数名)，会假设这个符号是在其他某个模块中定义的，并生成一个链接器符号表，交给链接器来处理。

如果链接器在所有模块内都找不到被引用的符号，就会输出错误信息被终止。

Linux 链接器解析全局符号的规则：
1. 不允许有多个同名的强符号
2. 如果有一个强符号和多个弱符号同名，则则选择强符号
3. 若果有多个弱符号同名，则随机选择一个

强符号：函数和已初始化的全局变量
弱符号：未初始化的全局变量

### 静态库链接

将部分相关的目标模块打包成一个单独的文件，成为静态库(static library)。

当链接器构造一个输出的可执行文件时，它只复制静态库中被应用程序引用的目标模块。

在Linux系统中，静态库以一种称为 存档(archive)的特殊文件格式粗放在磁盘中。

存档文件是一组连接起来的可重定位目标文件的集合，有一个头部用来描述每个成员目标文件的位置和大小。

存档文件由后缀 .a 标识。

一个坑：在链接时，静态库一般放在命令行结尾。被依赖的库必须放在依赖它的后面链接。

### 重定位

完成符号解析后，代码中的每个符号引用和符号定义关联起来了。接下来要重定位，合并输入模块，并为每个符号重新分配地址。

重定位分两步：
- 重定位Section和符号定义。

链接器将所有的相同类型的Section合并成一个，然后根据符号新的地址修改符号表中符号定义的信息(section、value等)。此时，程序中的每个符号(函数和全局变量)都有唯一的运行时内存地址了。

- 重定位section中的符号引用。

链接器修改 代码节和数据节中对每个符号的引用，使他们指向正确的运行时地址。

**重定位条目**

代码的重定位条目放在 .rel.text 中，已初始化数据的重定位条目放在 .rel.data 中


### 动态链接共享库

共享库(dynamic linking shared library)是一个目标模块，在加载或运行时，可以加载到内存中，并和一个程序链接起来。

不同系统的动态库：

1. Linux 为 .so 文件
2. Windows 为 .ddl 文件
3. Mac 问 .dylib 文件



### Mach-O文件

![](./img/mach-o-1.gif)

#### 头部信息 mach_header 

记录一些元信息

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

magic 表示大端还是小端
    MH_MAGIC_64 // 64-bit big-endian magic
    MH_CIGAM_64 // 64-bit little-endian magic

cputype cpu类型
    CPU_TYPE_I386 => :i386,
    CPU_TYPE_X86_64 => :x86_64,
    CPU_TYPE_ARM => :arm,
    CPU_TYPE_ARM64 => :arm64,

cpusubtype 
    具体的CPU类型，区分不同版本的处理器

filetype
    MH_OBJECT => :object,
    MH_EXECUTE => :execute,
    MH_DYLIB => :dylib,

ncmds
    number of load commands

sizeofcmds
    size of load commands

更多参考：https://www.rubydoc.info/github/Homebrew/ruby-macho/MachO

```

#### Load Command

记录 如何加载每个 section 的信息


#### Mach-O 中的 segment

一个目标文件中包含不同区域，每个区域被称为 **segment**

segment 具体分为：

**__TEXT** 

代码段。权限：只读，可执行。

- .text  可执行的机器码
- .cstring 去重后的c字符串
- .const 初始化过的常量
- .stubs 符号桩。本质上是一小段会直接跳入lazybinding的表对应项指针指向的地址的代码。
- .stub_helper 辅助函数。上述提到的lazybinding的表中对应项的指针在没有找到真正的符号地址的时候，都指向这。

**__DATA** 

数据。权限：可读写和不可执行。

- .data 初始化过的可变数据
- .const 没有初始化过的常量
- .bss  没有初始化过的静态变量
- .common   没有初始化过的符号声明
- .mod_init_func   初始化函数，在main之前调用
- .mod_term_func   终止函数，在main返回之后调用
- .nl_symbol_ptr	非lazy-binding的指针表，每个表项中的指针都指向一个在装载过程中，被动态链机器搜索完成的符号
- .la_symbol_ptr	lazy-binding的指针表，每个表项中的指针一开始指向stub_helper

**__LINKEDIT**

包含需要被动态链接器使用的信息，包括符号表、字符串表、重定位项表等

**__PAGEZERO**

Catch访问NULL指针的非法操作的段


参考：https://satanwoo.github.io/2017/06/13/Macho-1/
https://satanwoo.github.io/2017/06/29/Macho-2/

### iOS中动态库 dylib





### 参考


在运行时，虚拟内存会把 segment 映射到进程的地址空间，按需加载(mmap技术)