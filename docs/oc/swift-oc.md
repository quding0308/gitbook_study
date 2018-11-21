### Swift 与 ObjC 对比

- Swift 更注重安全性、简单，oc更注重 灵活性
- Swift 更注重值类型的数据结构，oc以c语言为基础，注重指针和索引
- Swift 为静态语言，oc为动态语言，有runtime，可以在运行时动态增加class、修改方法
- Swift 支持函数编程、面向协议编程、面向对象编程，oc支持面向对象编程

#### Swift 中把String、Array、Dictionary设计为值类型，在oc中为引用类型

- 值类型相比引用类型，最大优势在可以**高效实用内存**。值类型在栈上操作，引用类型在堆上操作
- 值类型是线程安全的，不必担心多线程对String、Array、Dictionary的操作


#### as 操作


#### extension 的使用



#### protocol 的使用



#### static 与 class



#### Struct 和 Class

共同点：

- 都可以定义 store value
- 都可以定义 method
- 都可以定义 subscripts
- 都可以可以定义init
- 都可以定义extension
- 都可以conform protocol

不同点：

- Class可以继承，struct 不可以
- Class 可以在runtime阶段 使用 as (type casting)来检查class type
- Class 可以使用 deinit 方法 释放资源
- Class 通过 引用计数 来实现引用控制

Class 额外的capcity增加了Class的复杂度和开销，所以尽量使用struct 和 enum 更简单。

Value Type 指 

```
A value type is a type whose value is copied when it’s assigned to a variable or constant, or when it’s passed to a function.
```


#### === 与 ==

**===** 用来判断 两个obj reference 是否指向同一个obj
**==** 使用的是 Equtable

