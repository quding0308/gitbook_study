
#### 单链表翻转

    class Node {
        var value: Int = 0
        
        var next: Node?
    }


    /// 单链表 翻转

    /// 非递归方法 遍历 改变每个node的next的指向
    /// 使用两个指针配合工作，使得两个节点间的指向反向，同时用r记录剩下的链表。
    func reverseList2(head: Node?) -> Node? {
        var pre = head
        var cur = head?.next
        
        head?.next = nil
        while let _ = cur {
            let tmp = cur?.next
            cur?.next = pre
            
            pre = cur
            cur = tmp
        }
        
        return pre
    }

    /// 非递归方法 遍历 每次取一个放入到第一个元素中
    /// 对于一条链表，从第2个节点到第N个节点，依次逐节点插入到第1个节点(head节点)之后，(N-1)次这样的操作结束之后将第1个节点挪到新表的表尾即可。
    /// 代码跟上面的一样 但思路不太一样
    func reverseList3(head: Node?) -> Node? {
        var curHead = head
        var next = curHead?.next
        
        while let _ = next {
            let tmp = next?.next
            
            next?.next = curHead
            curHead = next
            next = tmp
        }
        
        head?.next = nil
        return curHead
    }

    /// 递归操作 思路
    /**
    链表：a->b->c->d
    
    递归过程：
    a->b->c->d
        a->(b->c->d)
            a->(b->(c->d))
            a->(b->(c<-d))
        a->(b<-c<-d)
    a<-b<-c<-d
    
    */
    func reverseList(head: Node?) -> Node? {
        if let next = head?.next {
            var newHead = reverseList(head: next)
            
            newHead?.next = head
            head?.next = nil
            return newHead
        }
        
        return head
    }