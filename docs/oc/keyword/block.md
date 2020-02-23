# block

问题：
- property 中 block 使用 copy 修饰吗？
- __block 原理



block的实质，就是一个struct，包含了一个指向函数首地址的指针，和一些与自己相关的成员变量。

``` c
struct __block_impl 

struct __main_block_impl_0 {
  struct __block_impl impl;    
  struct __main_block_desc_0* Desc;
  __Block_byref_a_0 *a; // by ref
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, __Block_byref_a_0 *_a, int flags=0) : a(_a->__forwarding) {
    impl.isa = &_NSConcreteStackBlock;    // 类型
    impl.Flags = flags;
    impl.FuncPtr = fp;    // / 要执行的函数指针
    Desc = desc;
  }
};

// 使用
static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
  __Block_byref_a_0 *a = __cself->a; // bound by ref
  int b = (a->__forwarding->a);
  int m = 10;
}
```

## Block类型

NSConcreteStackBlock 是由编译器自动管理，超过作用域之外就会自动释放了。   
而 NSConcreteMallocBlock 是由程序员自己管理，如果没有被强引用也会被销毁。   
NSConcreteGlobalBlock 由于存在于全局区，所以会一直伴随着应用程序。

### NSConcreteGlobalBlock
未捕获任何变量或仅捕获的变量为静态类型、全局变量或静态全局变量的 Block 是 NSConcreteGlobalBlock
// 在运行时不需要再分配内存，会提高效率

```
NSLog(@"%@",^(void) {});

static NSString *name2;
void(^block2)(NSString *) = ^(NSString *param) {
    NSLog(@"=== %@ %@", param, name2);
};

```

### NSConcreteStackBlock

捕获了除静态类型、全局变量或静态全局变量之外的变量，block 就是存储在 stack 上。

``` 
int stackValue;
__weak void (^block4)(void) = ^{ stackValue; };

int a;
NSLog(@"%@",^(void) { a; });
```

### NSConcreteMallocBlock。

系统不提供直接创建 NSConcreteMallocBlock 的方式，但是可以对 NSConcreteStackBlock 进行 copy 操作来生成 NSConcreteMallocBlock。

以下情况，Block 会进行 copy 操作：

- 将 Block 赋值给 __strong 修饰符修饰（系统默认）的 Block 或者 id 对象
- 作为方法的返回值
- 系统 API 中含有 usingBlock 的方法

```
int stackValue;
void (^block4)(void) = ^{ stackValue; };
```

## 变量

任意类型的变量都可以在 Block 中被访问，但是能够被修改的变量只有以下三种：
- 静态变量
- 全局变量
- 静态全局变量

全局变量和静态全局变量由于存在于全局区作用域广，所以在 Block 内部能够直接修改。

静态变量是指针传递，局部变量是值传递，不可修改。

参考：https://xiaozhuanlan.com/topic/2710695843

## Property 和 Ivar

Property 也是 对 Ivar 的操作。

Ivar 可以在 block 中修改。对 Ivar 的操作是以 self 作为及地址，根据 Ivar 的偏移量操作 Ivar 存数的数据。

参考：https://xiaozhuanlan.com/topic/2710695843

## __block

局部变量被 __block 修饰后，可以在 block 中修改。此时局部变量会在编译时编程一个 struct ，sturct 中存储变量的值。通过在 block 中引用 struct 指针，可以保证在 block 外和 block 内部修改同一个 struct 的数据。 

参考：https://xiaozhuanlan.com/topic/2710695843

## 


## 反编译看代码
oc -> c++
``` shell
clang -rewrite-objc main.m
```

``` c
typedef void(^Block)(void);

int main(int argc, char * argv[]) {
//    @autoreleasepool {
//        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
//    }
    __block int a = 10;

    Block block1 = ^() {
      // print("123");
      
      a = 11;
      // self.string = @"456";
    };
}

/////////////编译后的代码////////////

//变量a的处理：a会对应生成一个struct：
struct __Block_byref_a_0 {
  void *__isa;
__Block_byref_a_0 *__forwarding;
 int __flags;
 int __size;
 int a;
};

// block 生成一个struct，里面有 对应的函数指针和 a的struct
struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  __Block_byref_a_0 *a; // by ref
  __main_block_impl_0(void *fp, struct __main_block_desc_0 *desc, __Block_byref_a_0 *_a, int flags=0) : a(_a->__forwarding) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};

// 函数指针
static void __main_block_func_0(struct __main_block_impl_0 *__cself){
  __Block_byref_a_0 *a = __cself->a; // bound by ref
        (a->__forwarding->a) = 11;
}
```


## 参考

- https://xiaozhuanlan.com/topic/2710695843
- https://mp.weixin.qq.com/s/XqMIoqJ0a4BzWlozO5whDg
- c 语言中 block 的使用：http://blog.quding0308.com/blog/2018/11/29/c-block.html