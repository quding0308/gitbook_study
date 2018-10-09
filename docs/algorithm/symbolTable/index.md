
### 符号表  

英文 Symbol Table，简称 SB

符号表是一种典型的抽象数据类型 ADT 。它最主要的目的就是将一个键和一个值联系起来。

定义的api如下

    /// Symbol Table
    class ST<Key, Value> {
        func put(key: Key, value: Value)
        
        func get(key: Key) -> Value?
        
        func delete(key: Key)
        
        func contains(key: Key) -> Bool
        
        func isEmpty() -> Bool
        
        func size() -> Int
    }

### 符号表的几种实现

- 基于无序链表实现
- 基于有序数组实现
- 基于散列表实现
