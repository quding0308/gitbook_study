## Swift 中 where 的使用

#### where 在 switch、for in 语句上 增加限制条件

```
var arr = [Int]()
arr.append(1)
arr.append(2)
arr.append(3)

for elemnet in arr where elemnet == 2 {
    print(elemnet)
}

arr.forEach { (value) in
    switch value {
    case let x where x > 2:
        print("\(x) 大于2")
    default:
        print("default")
    }
}
```

#### 在 do catch 里面使用
```
enum ExceptionError: Error {
    case httpCode(Int)
}

func throwError() throws {
    throw ExceptionError.httpCode(404)
}

func test1() {
    do {
        try throwError()
    } catch ExceptionError.httpCode(let code) where code > 500 {
        print(404)
    } catch {
        print("other err")
    }
}
```

#### 只给遵守 MyProtocol 协议的 MyClass类或子类增加扩展

```
// 与协议结合
protocol MyProtocol {
    //
}

class MyClass {
    //
}

// 只给遵守 MyProtocol 协议的 MyClass类或子类增加扩展
extension MyProtocol where Self: MyClass {
    func getName() -> String {
        return "MyClass"
    }
}

class SubClass: MyClass, MyProtocol {
    //
}
```

#### 在 associatedtype 后面声明的类型后追加 where 约束语句

```
protocol MyProtocol {
    associatedtype Element where Element: MyClass
}

class MyClass {
    //
}
```