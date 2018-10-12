

### 斐波那契数列

又称为 黄金分割数列 或 兔子数列

黄金分割
随着数列项数的增加，前一项与后一项之比越来越逼近黄金分割的数值0.6180339887..

指的是这样一个数列： 
    
    0、1、1、2、3、5、8、13、21、34、...

数学表示：

    f(1) = 1
    f(2) = 1
    f(n) = f(n -1) + f(n - 2)


程序表示：

    /// 递归表示 斐波那契数列
    /// 时间复杂度为 O(2^n)
    ///
    /// - Parameter n: 数列中第n位的值
    /// - Returns:
    func fibonacci_recursion(n: UInt) -> UInt {
        if n == 0 {
            return 0
        } else if n == 1 {
            return 1
        }
        
        return fibonacci_recursion(n: n - 1) + fibonacci_recursion(n: n - 2)
    }

    复杂度计算：f(4)的表示

                    f(4)
                    /   \ 
                 f(3)    f(2) 
               /    \    /   \ 
            f(2)   f(1) f(1) f(0) 
            /   \        
           f(1) f(0) 

    一个k层满二叉树的节点数为 2^k - 1
    f(n)是一个树高为n的二叉树 近似计算复杂度为 O(2^n)


    /// 迭代计算 斐波切纳数列
    /// 时间复杂度为 O(n) 空间复杂度为 O(1)
    /// - Parameter n:
    /// - Returns:
    func fibonacci_iterator(n: UInt) -> UInt {
        if n == 0 {
            return 0
        } else if n == 1 {
            return 1
        } else {
            var a: UInt = 1
            var b: UInt = 1
            var c: UInt = 1
            
            for _ in 2..<n {
                c = a + b
                a = b
                b = c
            }
            
            return c
        }
    }

    /// 还有一种使用矩阵计算的思路，复杂度为O(log(n)