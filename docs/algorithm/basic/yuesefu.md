
### 约瑟夫问题

问题描述：

N个人围成一圈，从第一个开始报数，第M个将被杀掉，最后剩下一个，其余人都将被杀掉。

例如N=6，M=5，被杀掉的顺序是：5，4，6，2，3，1。

#### 解法

用循环单链模拟整个过程，时间复杂度为O(m*n)

    class Node {
        var next: Node?
        var index: Int
        
        init(index: Int) {
            self.index = index
            print(index)
        }
    }

    func createCycle(n: Int) -> Node? {
        let head = Node(index: 1)
        
        var node = head
        var count = 1
        while count < n {
            count += 1
            
            let next = Node(index: count)
            
            node.next = next
            node = next
        }
        node.next = head // 单链环
        
        return head
    }

    func run(total: Int, tag: Int) {
        let head = createCycle(n: total)
        
        let start = 1
        var index = start
        var node: Node? = head
        var pre: Node?
        while node !== node?.next {
            if index == tag {
                print("index \(node?.index ?? -1)")
                pre?.next = node?.next
                node = pre?.next
                
                index = start
            } else {
                pre = node
                node = node?.next
                index += 1
            }
        }
        print("last one \(node?.index ?? -1)")
    }


    run(total: 6, tag: 5)
    tag = 1 时 死循环了

[参考](https://zh.wikipedia.org/wiki/%E7%BA%A6%E7%91%9F%E5%A4%AB%E6%96%AF%E9%97%AE%E9%A2%98#C++%E7%89%88%E6%9C%AC)