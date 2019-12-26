
队列是一种操作受限的线性表。支持enqueue和dequeue操作。

### 使用数组实现

``` Swift
public struct Queue<T> {
    fileprivate var array = [T?]()
    fileprivate var head = 0
    
    public var isEmpty: Bool {
        return count == 0
    }
    
    public var count: Int {
        return array.count - head
    }
    
    public mutating func enqueue(_ element: T) {
        array.append(element)
    }
    
    public mutating func dequeue() -> T? {
        guard head < array.count, let element = array[head] else { return nil }
        
        array[head] = nil
        head += 1
        
        let percentage = Double(head) / Double(array.count)
        if array.count > 50 && percentage > 0.25 {
            array.removeFirst(head)
            head = 0
        }
        
        return element
    }
    
    public var front: T? {
        if isEmpty {
            return nil
        } else {
            return array[head]
        }
    }
}
```

### 使用链表实现 

``` Swift
public struct Queue<T> {
    fileprivate var head: Node<T>?
    fileprivate var tail: Node<T>?
    
    public mutating func enqueue(_ element: T) {
        let node = Node(element)
        
        if head == nil {
            head = node
        }
        
        if let tail = tail {
            tail.next = node
        }
        tail = node
    }
    
    public mutating func dequeue() -> T? {
        guard let head = head else { return nil }
        
        let node = head
        self.head = head.next
        
        return node.value
    }
}

class Node<T> {
    var value: T
    var next: Node<T>?
    
    init(_ v: T) {
        value = v
    }
}
```

### 循环队列

环形数据结构不再需要数据搬移
``` Swift
public class CircularQueue {
    // 数组：items，数组大小：n
    private String[] items;
    private int n = 0;
    // head 表示队头下标，tail 表示队尾下标
    private int head = 0;
    private int tail = 0;

    // 申请一个大小为 capacity 的数组
    public CircularQueue(int capacity) {
        items = new String[capacity];
        n = capacity;
    }

    // 入队
    public boolean enqueue(String item) {
        // 队列满了
        if ((tail + 1) % n == head) return false;
        items[tail] = item;
        tail = (tail + 1) % n;
        return true;
    }

    // 出队
    public String dequeue() {
        // 如果 head == tail 表示队列为空
        if (head == tail) return null;
        String ret = items[head];
        head = (head + 1) % n;
        return ret;
    }
}
```

#### 阻塞队列

在队列的基础上增加了阻塞操作。如果队列为空，从队头取数据会被阻塞；如果队列满了，从队尾插入数据会被阻塞，知道队列中有空闲位置可以再插入数据然后才返回。

### 待学习：

- linux中使用的环形队列：https://www.cnblogs.com/Anker/p/3481373.html
- Disruptor队列介绍：https://tech.meituan.com/disruptor.html