## Closure 和 Function
  
Function 是特殊的 Closure，Function 分为 Global Function 和 Nested Function。

Closure 有3种情况：
1. Global Function。有 name ，并且没有 capture 任何值 
2. Nested Function。有 name，并且在定义范围内(enclosing funtion)可以 capture 值。
3. Closure Expression。没有 name，能够 capture 上下文中的值


### Closure Expression Syntax

``` Swift
/// 声明 Cloruse 类型：
(param) -> return_value

/// 实现：
{ (param) -> return_value in
    statements
    ...
}

param 可以为 in-out 参数，但不可以设置默认值。() 表示参数为空

示例：
// 声明
var checkClosure: ((Bool) -> Void)?

// 实现
checkClosure = { [weak self] () -> Void in
            self?.isLunar = false
        }
```


### 语法的优化

#### 根据上下文推断参数和返回值的类型

``` Swift
let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]

func sort(_ a: String, _ b: String) -> Bool {
    return true
}

let sort1: (String, String) -> Bool = { (a: String, b: String) -> Bool in
    return true
}

let sort2: (String, String) -> Bool = { (a: String, b: String) in
    return true
}

let sort3 = { (a: String, b: String) in
    return true
}

_ = names.sorted(by: sort2)

reversedNames = names.sorted(by: { s1, s2 in return s1 > s2 } )

reversedNames = names.sorted(by: { s1, s2 in s1 > s2 } )

reversedNames = names.sorted(by: { $0 > $1 } )

reversedNames = names.sorted(by: >)

```

#### Trailing Closures

``` Swift
func someFunctionThatTakesAClosure(closure: () -> Void) {
    // function body goes here
}

// 调用：
someFunctionThatTakesAClosure() {
    // trailing closure's body goes here
}

```

### Closure 是 引用类型

引用类型，不是值类型。


### Escaping Closure

如果一个闭包被作为一个参数传递给一个函数，并且在函数return之后才被唤起执行（return后 不会被销毁），那么这个闭包是逃逸闭包。

使用场景：
- 异步执行。函数 return 后，异步执行 闭包。
- 闭包存储在全局变量中，等待以后使用。

``` Swift
var completionHandlers: [() -> Void] = []
func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
    completionHandlers.append(completionHandler)
}
```







