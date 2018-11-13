### block

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


#### Block类型

```
{
    // 全局的静态block，不会访问任何外部变量
    NSConcreteGlobalBlock;

    // 保存在栈中的block，出栈时会被销毁
    NSConcreteStackBlock;

    // 保存在堆中的block，当引用计数为0时会被销毁
    NSConcreteMallocBlock;//分配在堆中
｝
```

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
//        print("123");
        
        a = 11;
        //        self.string = @"456";
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






### 参考

- https://mp.weixin.qq.com/s/XqMIoqJ0a4BzWlozO5whDg