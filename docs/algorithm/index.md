
## 数据结构与算法

> Bad programmers worry about the code. 
> Good programmers worry about data structures and their relationship

特定数据结构是对特定场景的抽象

数据结构是为算法服务的，具体选择哪种存储方法，与期望支持的操作有关系。

常见用途：
- 提高效率。例如 排序、查找的不同算法，尽量降低时间复杂度，提高效率
- 为了解决某一领域的问题。例如图
- 使用某种算法可以简化计算方式，一般通过 数学来简化或转化为另一个问题

算法是抽象出的模型，学习完后需要应用于具体的编程实例中

学习的过程：
1. 学习不同算法和数据类型，各自的优缺点和实际应用场景
2. 通过阅读源码学习具体算法的使用
3. 在编程中可以熟练使用不同算法

解算法题分两步：

- 拿到题选什么算法
- 如何实现这个算法

**Why learn algorithms and data structures?**

https://github.com/raywenderlich/swift-algorithm-club/blob/master/Why%20Algorithms.markdown

**What are algorithms and data structures?**

https://github.com/raywenderlich/swift-algorithm-club/blob/master/What%20are%20Algorithms.markdown

**Algorithm design techniques**

https://github.com/raywenderlich/swift-algorithm-club/blob/master/Algorithm%20Design.markdown

### 单词 

``` shell
Divide and conquer 分而治之，各个击破

brute force 暴力破解，蛮力

premature optimization 过早优化

traverse 遍历
traverseInOrder 中序遍历
traversePreOrder 前序遍历
traversePostOrder 后续遍历

orderCriteria 排序标准
shift 转移，变换
shift down 下沉
stride 跨步

Naive, brute force solutions are often too slow for practical use but they're a good starting point. By writing the brute force solution, you learn to understand what the problem is really all about.

Once you have a brute force implementation you can use that to verify that any improvements you come up with are correct.

And if you only work with small datasets, then a brute force approach may actually be good enough on its own. Don't fall into the trap of premature optimization!
```


### 道理

刘润对谈吴军：每个人都一定要有数学思维

https://www.chons.cn/64286.html

写递归代码的关键就是找到如何将大问题分解为小问题的规律，并且基于此写出递推公式，然后再推敲终止条件，最后将递推公式和终止条件翻译成代码。









## 参考

- https://www.lintcode.com/
- https://www.zhihu.com/question/25693637/answer/747872819
- https://www.zhihu.com/question/26934313/answer/743798587
