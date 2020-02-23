# c语言

Xcode 中默认使用的是 **gun11**

```
国际标准组织发布c11后，gnu为自己的编译器发布两种标准gnu11和c11

gnu11：带gnu c扩展的c11标准，如果你的代码包含了typeof，__attribute__等等gnu的扩展，就必须用这个。

c11：这个就是纯c11的标准，不带gnu扩展。

-std=gnu11

```

## 内存分配

内存分为4个区：TEXT、DATA、堆、栈

静态内存分配包括 TEXT、DATA。

动态内存分配包括堆和栈，在运行时分配。

栈 Stack 存储局部变量。栈是向低地址生长的数据结构，是一块连续的内存，能从栈中获得的内存较小，编译期间确定大小。

堆 heap ，需要程序员手动管理的内存区域。堆是向高地址生长的数据结构，是一个不连续的储存空间，内存获取比较灵活，也较大。c 语言中使用 malloc、calloc、realloc、free 来申请或释放内存。

### malloc
``` c
void * malloc (size_ t size) ;
功能:
1.开辟一块size大小的连续堆内存。
2.size表示堆 上所开辟内存的大小(字节数)。
3.函数返回值是一个指针，指向刚刚开辟的内存的首地址。
4.如果开辟内存失败， 返回一个空指针，即返回值为NULL。
5.当内存不再 使用时，应使用free ()函数将内存块释放

int *z;
z = malloc(sizeof(int));
*z = 10;
free(z);
z = NULL;
```

### calloc
``` c
函数原型: void * calloc(size_ t n, size t size);
功能:
1.在内存的动态存储区中分配n个长度为si ze的连续空间，
2.函数返回一个指向分配起始地址的指针;
3.如果分配不成功，返回NULL。
4.当内存不再 使用时，应使用free ()函数将内存块释放。

int *zArray;
zArray = calloc(2, sizeof(int));
*zArray = 12;
*(zArray+1) = 15;
//    *(zArray+2) = 17;
free(zArray);
zArray = NULL;
```

### realloc
``` c
void * realloc(void * mem_ address, size_ t newsize) ;
功能:
1.为已有内存的变量重新分配新的内存大小(可大、可小) ;
2.先判断当前的指针是否有足够的连续空间，如果有，扩大mem_address指向的地址，并且将mem_ address返回;
3.如果空间不够，先按照newsize指定的大小分配空间，将原有数据从头到尾拷贝到新分配的内存区域，而后释放原来mem_address 所指内存区域(注意:原来指针是自动释放，不需要使用free),同时返回新分配的内存区域的首地址。即重新分配存储器块的地址。
4.如果重新分配成功则返回指向被分配内存的指针;
5.如果分配不成功，返回NULL。
6.当内存不再使用时，应使用free ()函数将内存块释放

zArray = realloc(zArray, sizeof(int)*3);
*zArray = 12;
*(zArray+1) = 15;
*(zArray+2) = 17;
free(zArray);
zArray = NULL;
```

## malloc、calloc、realloc、free 实现原理

也即 ”如何管理堆内存的申请和分配“

参考：https://blog.csdn.net/zxx910509/article/details/62881131

## 字节对齐

- 字节对齐主要是为了提高内存的访问效率
- 在编译阶段会做字节对齐
- 一般是对 struct 中的变量的存储做字节对齐
- sizeof() 计算的大小为字节对齐后占用内存的大小
 
例如， 64 位的 iPhone 手机上，每次从内存读取8个字节。一个 struct 的起始位置，必须能被 8 整除（编译器可能在 struct 之间填充字节保证 struct 的起始位置能被8整除）。

字节对齐规则：
1. 结构体变量的首地址能够被其最宽基本类型成员的大小所整除；
2. 结构体中的每个成员相对于起始地址的偏移能够被其自身大小整除，如果不能则在前一个成员后面补充字节。
3. 结构体总体大小能够被最宽的成员的大小整除，如不能则在后面补充字节。

``` c
#define SHW_VAR_ADR(ID, I)                    \
printf("the  %s  is at adr:%p\n", ID, &I); //打印变量地址宏

struct test_t {
    char a;
};

printf("%lu\n", sizeof(struct test_t));

struct test_t test;
SHW_VAR_ADR("a", test.a);

struct test_t test1;
SHW_VAR_ADR("a", test1.a);

输出：
test_t 大小为 1
the  test.a  is at adr:0x7ffeeeca4cf8
the  test1.a  is at adr:0x7ffeeeca4cf0

// test 占 1 个字节，后面填充 7 个字节，然后存储 test1
```

``` c
// test_t 内存布局为：48 = 1 + (3) + 4 + (8) + 16 + 1 + (3) + 4 + (8)
struct test_t {
    char a;
    int b;
    long double c;
    char d;
    int e;
};

printf("%lu\n", sizeof(struct test_t));
struct test_t test;
SHW_VAR_ADR("a", test.a);
SHW_VAR_ADR("b", test.b);
SHW_VAR_ADR("c", test.c);
SHW_VAR_ADR("d", test.d);
SHW_VAR_ADR("e", test.e);

输出：
48
the  a  is at adr:0x7ffee479ecf0
the  b  is at adr:0x7ffee479ecf4
the  c  is at adr:0x7ffee479ed00
the  d  is at adr:0x7ffee479ed10
the  e  is at adr:0x7ffee479ed14
the  a  is at adr:0x7ffee479ecc0
```



## 参考

- https://zhuanlan.zhihu.com/p/52125577
- https://www.zfl9.com/c-point-library.html#%E5%86%85%E5%AD%98%E6%BA%A2%E5%87%BA-%E5%86%85%E5%AD%98%E6%B3%84%E6%BC%8F-%E5%86%85%E5%AD%98%E8%B6%8A%E7%95%8C-%E7%BC%93%E5%86%B2%E5%8C%BA%E6%BA%A2%E5%87%BA-%E6%A0%88%E6%BA%A2%E5%87%BA

