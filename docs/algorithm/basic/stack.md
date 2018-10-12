
栈是一种操作受限的线性表。当某个数据集合只涉及某一端插入和删除数据，并且满足先进后出的特性，我们就可以用 栈 这种数据结构。


    public struct Stack<T> {
        fileprivate var array = [T]()
        
        public var count: Int {
            return array.count
        }
        
        public var isEmpty: Bool {
            return array.isEmpty
        }
        
        public mutating func push(_ element: T) {
            array.append(element)
        }
        
        public mutating func pop() -> T? {
            return array.popLast()
        }
        
        public var top: T? {
            return array.last
        }
    }

    class Stack1<Element> {
        var head: Node1<Element>?
        
        func push(_ element: Element) {
            if head == nil {
                head = Node1(element)
                return
            }
            
            let node = Node1(element)
            node.next = head
            head = node
        }
        
        func pop() -> Element? {
            let node = head
            head = head?.next
            
            return node?.value
        }
    }

    class Node1<Element> {
        var value: Element
        var next: Node1<Element>?
        
        init(_ v: Element) {
            value = v
        }
    }

## 具体实例
### 浏览器的前进、后退操作

使用两个栈记录页面

    // 打开了 a b c 三个页面
    stack1 push a b c
    stack2 为空

    // 后退到a页面
    stack1 pop c、b，此时stack1数据为 a
    stack2 push c、b 此时stack2数据为 c、b

    // 前进到b页面
    stack1：a、b
    stack2：c

    //打开一个新页面d
    stack1：a、b、d
    stack2 清空

#### 栈在括号中匹配的应用

检测一个表达式中 {} [] () 是否匹配

原理：在一个stack中存储括号，遇到左括号则入栈，遇到右括号 则从stack pop一个左括号，看是否匹配。有一个不匹配，则表达式有问题。

#### 栈在表达式求值中的应用

算术表达式 3 + 9 × 2 - 5 + 6 × 3

使用两个栈，stack1 存储数字，stack2 存储运算符。每次遇到运算符n后，从stack2中pop运算符m作比较，如果m优先级更高，则从stack1取数字先进行m的运算，结果保存到stack1中，之后从stack2 pop一个新的运算符 以此类推

    stack1 3、9
    stack2 +

    stack1 3、9、2
    stack2 +、 × 

    // 遇到运算符 -， × 优先级更高，先进行  ×  
    stack1 3、18
    stack2 +

    // 遇到 -， 先进行 +
    stack1 21
    stack2 

    stack1 21、5
    stack2 -

    // 遇到 +，先进行 - 
    stack1 16
    stack2 

    stack1 16、6
    stack2 +

    stack1 16、6、3
    stack2 +、 × 
    
    stack1 16、18
    stack2 +

    stack1 34
    stack2 

    // result = 34    
    