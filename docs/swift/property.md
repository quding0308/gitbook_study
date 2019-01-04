## Property

### Stored Property

1. Stored Property 可以为 var 或 let ，会存储 value 作为对象的一部分
2. Stored Property 可以设置默认值
3. 可以在 init 方法中修改 Stored Property 的值(let 也可以修改)

``` Swift
var firstName: String = ""
var lastName: String?
```

Class 和 Struct 的使用区别：

``` Swift
class Person {
    var firstName: String = ""
    var lastName: String
    
    // class 的 Stored Property 在 init 的时候必须初始化
    init(_ lastName_: String) {
        lastName = lastName_
    }
}

struct FixedRange {
    var firstValue: Int
    let length: Int
}

// class 为 reference type，如果为let，仍然可以修改 var property 
let person = Person("LBJ")
person.firstName = "Peter"
person.lastName = "LBJ"

// struct 为 value type，如果为let，则所有的 property 都为let，不可修改
let range = FixedRange(firstValue: 5, length: 10)
range.firstValue = 6    // 编译错误
```

#### Lazy Stored Property

Lazy Stored Property 的初始化会延迟到 第一次被调用

``` Swift
class DataManager {
    lazy var importer = DataImporter()
    var data = [String]()

    lazy var fullName = {
        // 注意：正常只会调用一次；但如果多线程操作，无法保证只初始化一次
        return firstName + lastName
    }()****
}
```

### Computed Property

Computed Property 不会存储值，会默认生成 getter 方法，默认没有 setter 方法，可以自定义设置 setter 方法。

class/struct/enum 可以定义 Computed Property。

``` Swift
var firstName: String = ""
var lastName: String = ""

// default getter，没有 setter， readonly
var fullName: String {
    return firstName + lastName
}

// 显示的 getter，没有 setter， readonly
var fullName: String {
    get {
        return firstName + lastName
    }
}

// setter and **getter**
var fullName: String {
    get {
        return firstName + lastName
    }
    set(newName) {
        firstName = newName
    }
}

// setter 的简写
var fullName: String {
    get {
        return firstName + lastName
    }
    set {
        firstName = newValue
    }
}

// Computed Property 调用：
_ = person.fullName
person.fullName = ""

//// 实际作用等价于下面的函数 
func fullName() -> String {
    return firstName + lastName
}
func fullName(_ newName: String) {
    firstName = newName
}

// 函数调用
_ = person.fullName()
person.fullName("")
```


### Property Observer

1. Observer 分为 willSet 和 didSet 两种
2. 可以为 Stored Property 添加 Observer（不可以给 Lazy Stored Property 添加 Observer）
3. class：继承的 Stored Property 和 Computed Property 都可以添加 Observer（overriding Property）
4. 对于自己定义的 Computed Property 并不需要添加 Observer，可以直接在 setter 中处理()
5. 在 init 中初始化的时候，不会调用 Observer

``` Swift
class Animal {
    var firstName: String {
        get {
            return ""
        }
        set {
            print("set")
        }
    }
    
    var age: Int = 0
}

class Person: Animal {
    var lastName: String = "" {
        willSet {
            print("old: " + lastName + ", new: " + newValue)
        }
        didSet {
            print("old: " + oldValue + ", new: " + lastName)
        }
    }
    
    // 这里会报错 lazy 无法添加 observer
//    lazy var firstName: String = "" {
//        willSet {
//            print("old: " + lastName + ", new: " + newValue)
//        }
//    }
    
    // override Stored Property
    override var age: Int {
        willSet {
            print("willSet age")
        }
        didSet {
            print("didSet age")
        }
    }
    
    // override Computed Property
    override var firstName: String {
        willSet {
            print("willSet")
        }
        didSet {
            print("didSet")
        }
    }
}
```

### Type Property

类似于 c 中的 static，必须有默认值(default value)

``` Swift
class Person {
    static var lastName: String = "" {
        willSet {
            print("old: " + lastName + ", new: " + newValue)
        }
        didSet {
            print("old: " + oldValue + ", new: " + lastName)
        }
    }

    static var firstName1: String {
        get {
            return ""
        }
        set {
            print("")
        }
    }
    
    // 使用 class 修饰 Computed Property ， subclass 可以 override
    class var firstName: String {
        get {
            return ""
        }
        set {
            print("")
        }
    }
}

struct FixedRange {
    static var firstValue: Int = 0
    let length: Int
}

enum KDError {
    case networkError
    
    static var firstValue: Int = 0
}

// 调用方式：
Person.lastName = ""
FixedRange.firstValue = 10
```


### 参考 
- https://docs.swift.org/swift-book/LanguageGuide/Properties.html#ID255