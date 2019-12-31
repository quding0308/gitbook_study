# 链表 LinkedList

顺序表 是在计算机内存中以数组的形式保存的线性表，是指用一组地址连续的存储单元依次存储数据元素的线性结构。

链表 是一种线性表。但是并不会按线性的顺序存储数据，而是每一个节点存储下一个节点的指针。


|  |  随机插入  | 删除  | 访问随机元素 |
|  ---- |  ----  | ----  | --- |
| 顺序表  | O(n) | O(n) | O(1) |
| 链表  | O(1) | O(1) | O(n) |

链表类型：

- 单向链表
- 双向链表
- 循环链表
 

在链表的问题中，通过两个的指针来提高效率是很值得考虑的一个解决方案

## 单链表翻转

``` shell
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
        // 先记录剩余的链表
        let tmp = cur?.next
        // 修改 next 指向
        cur?.next = pre
        // 挪一位
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
```

### 在O(1)时间删除链表节点

从无头列表中删除某个节点，用下一个节点数据覆盖要删除的节点，然后删除下一个节点。但是如果节点是尾节点时，该方法就行不通了。

``` Swift
func deleteNode(node: Node) {
    let next = nodex.next

    node.value = next.value
    node.next = next.next
}
```

### 求链表倒数第k个节点

分析：设置两个指针 p1、p2，首先 p1 和 p2 都指向 head，然后 p2 向前走 k 步，这样 p1 和 p2 之间就间隔 k 个节点，最后 p1 和 p2 同时向前移动，直至 p2 走到链表末尾。

### 求链表的中间节点

题目描述：求链表的中间节点，如果链表的长度为偶数，返回中间两个节点的任意一个，若为奇数，则返回中间节点。

方法：可以先求链表的长度，然后计算出中间节点所在链表顺序的位置。但是如果要求只能扫描一遍链表，如何解决呢？最高效的解法和第3题一样，通过两个指针来完成。用两个指针从链表头节点开始，一个指针每次向后移动两步，一个每次移动一步，直到快指针移到到尾节点，那么慢指针即是所求。

### 编程判断两个链表是否相交

题目描述：给出两个单向链表的头指针

解题思路：

1. 转换为环的问题。把第二个链表接在第一个链表后面，如果得到的新链表有环，则说明两个链表相交。另外，也可以直接循环遍历第二个链看是否会回到起始点。
时间复杂度为线性，空间复杂度为常数
2. 如果两个没有环的链表相交于某一节点，那么在这个节点之后的所有节点都是两个链表共有的。尾部节点共有，分别遍历获取到两个节点的尾部节点看是否相同即可。

### 链表有环，如何判断相交

如果有环且两个链表相交，则两个链表都有共同一个环，即环上的任意一个节点都存在于两个链表上。因此，就可以判断一链表上俩指针相遇的那个节点，在不在另一条链表上。

### 两链表相交的第一个公共节点

题目描述：如果两个无环单链表相交，怎么求出他们相交的第一个节点呢？

### 合并两个有序的单链表，合并之后的链表依然有序

类似归并排序中合并两个有序数组为一个有序数组

### 以 k 个节点为段，反转单链表。

```
/**
 * 11、以 k 个节点为段，反转单链表。
 * Reverse Nodes in k_Group，Leetcode上的算法题，第6题的高级变种
 * @param head 链表头结点
 * @param k 每k个节点反转
 * @return 反转后的链表头
 */
public static ListNode reverseKGroup2(ListNode head, int k) {
    ListNode curr = null;
    int count = 0;
    while (curr != null && count != k) { // find the k+1 node
        curr = curr.next;
        count++;
    }
    if (count == k) { // if k+1 node is found
        curr = reverseKGroup2(curr, k); // reverse list with k+1 node as head
        // head - head-pointer to direct part,
        // curr - head-pointer to reversed part;
        while (count-- > 0) { // reverse current k-group
            ListNode tmp = head.next; // tmp - next head in direct part
            head.next = curr; // preappending "direct" head to the reversed list
            curr = head; // move head of reversed part to a new node
            head = tmp; // move "direct" head to the next node in direct part
        }
        head = curr;
    }
    return head;
}
```

## 如何判断一个单链表是否有环？

### 方式1：遍历链表 寻找是否有相同的地址 brute force

```
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
```

### 方式2：经典方式
```
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
```

#### 求环的入口

寻找环入口的方法就是采用两个指针，一个从表头出发，一个从相遇点出发，一次都只移动一步，当二者相等时便是环入口的位置

```
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
```

[参考](https://blog.csdn.net/sinat_35261315/article/details/79205157)


#### 求环的长度 

知道环的入口后，继续往下走  直到下次到入口走的距离就是 环的长度