### codable

涉及到的类：Codable、JSONEncoder、Mirror、JSONSerialization

### Codable 类转 Dict 

```
// public typealias Codable = Decodable & Encodable
struct Cat: Codable {
    var name: String
    var age: Int
}

let peter = Cat(name: "Peter", age: 12)
let encoder = JSONEncoder()

do {
    let data = try encoder.encode(peter)
    let dict = try JSONSerialization.jsonObject(with: data, options: [])
    
    print(dict)
} catch {
    print(error)
}
```

### Codable 转 String 
```
public extension Encodable {
    public func kd_jsonString() throws ->String? {
        let data = try JSONEncoder().encode(self)
        let str = String.init(data: data, encoding: String.Encoding.utf8)
        return str
    }
}
```

### KeyedEncodingContainer 与 KeyedDecodingContainer

JSONEncoder encode 对象的时候，基本基于 KeyedEncodingContainer

JSONDecoder decode json对象的时候，基本基于 KeyedDecodingContainer

可以通过 KeyedEncodingContainer 或 KeyedDecodingContainer 增加扩展，重写对应的encode decode 方法，提升 json 转 对象的兼容性

### 参考

- https://xiaozhuanlan.com/topic/9582316047