## Swift

官方文档：https://docs.swift.org/swift-book/

### 知识点：

- Basic
  - Basic Operation/Control Flow
  - Basic Type/String/Character/Collection Type
  - Function/Closures
- Enumeration/Structure/Class/Protocol
  - Property
  - Method
  - Initialization/Deinitialization
  - Extension
- Other
  - Subscript
  - Optional Chain
  - Error Handling
  - Type Casting
  - Nested Types
  - Generic
  - ARC/Memory Safety



### Range Operator

范围 a range of values

```
// Closed Range 左闭右闭 [1,5]
for index in 1...5 {
    //
}

// Half-Open Range Operator 左闭右开 [1,5)
for index in 1..<5 {
    //
}

// One-Side Range
for name in names[2...] {
    //
}

for name in names[...2] {
    // 0 1 2
}

for name in names[..<2] {
    // 0 1
}

let range = ...5

```

### Type Casting

#### 类型检测 is  type check operator

可以用来检测 是否是子类 或 实现了 protocol
```
for item in library {
    if item is Movie {
        print("Movie \(item.name)")
    } else if item is Song {
        print("Song \(item.name)")
    }
}
```

#### 类型转换 as? 与 as!

可以转成父类 或 实现的 protocol
```
// as? as!
for item in library {
    if let movie = item as? Movie {
        print("Movie: \(movie.name), dir. \(movie.director)")
    } else if let song = item as? Song {
        print("Song: \(song.name), by \(song.artist)")
    }
}

// 转成 Any 或者 AnyObject 直接使用 as 即可。
// as
for item in library {
    _ = item as? Movie
    _ = item as AnyObject
}
```

#### Any 与 AnyObject

**Any** 代表一个instance，包括 Function
**AnyObject** 代表一个Class 的 instance 