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
