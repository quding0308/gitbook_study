


 ### 二叉堆 binary heap
 
 本质是一个完全二叉树
 
 分为两类：
 
 1. 最大堆  root 为最大值
 2. 最小堆  root 为最小值
 
 ### 对外操作：
 
 - 插入新element
 - 获取最大或最小值
 
 ### 内部操作：
 
 - 插入节点
 - 插入节点后 下沉
 - 删除节点
 - 删除节点后 上浮
 
``` Swift

/**
 */
class BinaryHeap: NSObject {
    
    public func insert(_ element: Int) {
        
    }
    
    // 最大堆
    public func root() -> Int {
        return 0
    }
}

class MaxBinaryHeap: NSObject {
    
    private var array = [Int]()
    
    public func insert(_ element: Int) {
        array.append(element)
        
        MaxBinaryHeap.upValue(array: &array, index: array.endIndex)
    }
    
    // 最大堆
    public func root() -> Int? {
        let first = array.first
        
        // 把最后一个拿到root位置
        array.swapAt(array.startIndex, array.endIndex)
        
        array.removeLast()
//        array 的length就是真实的堆中的元素个数
        
        MaxBinaryHeap.downValueMaxHeap(array: &array, parrentIndex: 0)
        
        return first
    }
    
    /// 插入一个值后，执行up操作     【最后一个值up】
    ///
    /// - Parameters:
    ///   - array:
    ///   - index: childIndex
    fileprivate static func upValue(array: inout [Int], index: Int) {
        if index == 0 {
            return
        }
        
        let parentIndex = index / 2
        
        if array[parentIndex] < array[index] {
            array.swapAt(parentIndex, index)
        
            if parentIndex > 0 {
                // recursive 直到root
                upValue(array: &array, index: parentIndex)
            }
        }
    }
    
    /// 取出一个root后 用最后一个值填充，执行down操作    【root改变后 down】
    ///
    /// - Parameters:
    ///   - array:
    ///   - index: parentIndex
    fileprivate static func downValueMaxHeap(array: inout [Int], parrentIndex: Int) {
        if parrentIndex >= array.endIndex {
            return
        }
        
        var childIndex = parrentIndex * 2 + 1
        
        // 找到child node中大的那个
        if childIndex + 1 < array.count {
            if array[childIndex] < array[childIndex + 1] {
                childIndex += 1
            }
        }
        
        if array[childIndex] > array[parrentIndex] {
            array.swapAt(childIndex, parrentIndex)
            
            downValueMaxHeap(array: &array, parrentIndex: childIndex)
        }
    }
}

```
