## ARC 相关

### 类实例之间的循环引用

#### 1.两个类中的 property 都可能为 nil

``` Swift
class Person {
    let name: String
    init(name: String) { self.name = name }
    var apartment: Apartment?
    deinit { print("\(name) is being deinitialized") }
}

class Apartment {
    let unit: String
    init(unit: String) { self.unit = unit }
    weak var tenant: Person?
    deinit { print("Apartment \(unit) is being deinitialized") }
}
```

#### 2.两个类中的 property ，一个可能为 nil，另一个不可能为 nil

``` Swift
class Customer {
    let name: String
    var card: CreditCard?
    
    init(name: String) {
        self.name = name
    }
}

class CreditCard {
    let number: UInt64
    unowned var customer: Customer
    
    init(number: UInt64, customer: Customer) {
        self.number = number
        self.customer = customer
    }
}
```

#### 3.两个类中的 property 都不可能为 nil

``` Swift
class Country {
    let name: String
    var capitalCity: City!
    init(name: String, capitalName: String) {
        self.name = name
        self.capitalCity = City(name: capitalName, country: self)
    }
}

class City {
    let name: String
    unowned let country: Country
    init(name: String, country: Country) {
        self.name = name
        self.country = country
    }
}
```

### Closure 的循环引用

使用 Capture List 来避免循环应用。

**注意** 只有调用了 Closure 才会触发循环引用

#### 1.可能为 nil

使用 [weak self]

``` Swift
lazy var asHTML: () -> String = { [weak self] in
    if let text = self?.text {
        return "<\(self?.name)>\(text)</\(self?.name)>"
    } else {
        return "<\(self?.name) />"
    }
}
```

#### 2.不可能为 nil

使用 [unowned self]

``` Swift
lazy var asHTML: () -> String = { [unowned self] in
    if let text = self.text {
        return "<\(self.name)>\(text)</\(self.name)>"
    } else {
        return "<\(self.name) />"
    }
}
```







