
### 如何判断一个单链表是否有环？

#### 方式1：遍历链表 寻找是否有相同的地址

    func hasCircle2() -> Bool {
        var n = head
        while let node = n {
            var next = node.next
            if node === next {
                return true
            }
            
            while let node2 = next?.next {
                if node === node2 {
                    return true
                }   
                next = node2
            }
            n = node.next
        }
        
        return false
    }

    复杂度为n^2

#### 方式2：经典方式

    extension SinglyLinkedList {
        func hasCircle() -> Bool {
            var slowStep = head
            var quickStep = head?.next
            
            while let quick = quickStep, let slow = slowStep  {
                if quick === slow {
                    return true
                } else {
                    quickStep = quickStep?.next?.next
                    slowStep = slowStep?.next
                }
            }
            
            return false
        }
    }

    算法复杂度为O(n)

#### 求环的入口

寻找环入口的方法就是采用两个指针，一个从表头出发，一个从相遇点出发，一次都只移动一步，当二者相等时便是环入口的位置。

    func detectCycle() -> Node? {
        var slowStep = head
        var quickStep = head?.next
        
        var cross: Node? = nil
        while let quick = quickStep, let slow = slowStep  {
            if quick === slow {
                cross = quick
            } else {
                quickStep = quickStep?.next?.next
                slowStep = slowStep?.next
            }
        }
        
        var headWalker = head
        var crossWalker = cross
        while let _ = headWalker?.next, let _ = crossWalker?.next, headWalker !== crossWalker {
            crossWalker = crossWalker?.next
            headWalker = headWalker?.next
        }
        
        if headWalker === crossWalker {
            return headWalker
        }
        
        return nil
    }

数学推到：

[参考](https://blog.csdn.net/sinat_35261315/article/details/79205157)

![图片](http://pc5ouzvhg.bkt.clouddn.com/WechatIMG187.jpeg)

#### 求环的长度 

知道环的入口后，继续往下走  直到下次到入口走的距离就是 环的长度