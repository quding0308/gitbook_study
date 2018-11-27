### 最长公共子序列

最长公共子串（Longest Common Substring）与最长公共子序列（Longest Common Subsequence）的区别： 子串要求在原字符串中是连续的，而子序列则只需保持相对顺序一致，并不要求连续。例如X = {a, Q, 1, 1}; Y = {a, 1, 1, d, f}那么，{a, 1, 1}是X和Y的最长公共子序列。{1, 1} 是X和Y的最长公共子字符串。


### 思路

1. 最长公共子序列问题存在最优子结构：这个问题可以分解成更小，更简单的“子问题”，这个子问题可以分成更多的子问题
2. 最长公共子序列问题的子问题的解是可以重复使用的，也就是说，更高级别的子问题通常会重用低级子问题的解。

拥有这个两个属性的问题可以使用动态规划算法来解决，这样子问题的解就可以被储存起来，而不用重复计算。


求 "ABCBDAB" 与 “BDCABA”的最长公共子序列。

#### 1.建二维数组
使用一个二维数组存储子问题的结果方便复用，f[i][j]存储X[i]和Y[j]之前的最长公共子序列长度。

![img1](https://raw.githubusercontent.com/quding0308/gitbook_study/master/assets/images/lcsubsequence1.png)

#### 2.计算规则：

![imag2](https://raw.githubusercontent.com/quding0308/gitbook_study/master/assets/images/lcsubsequence2.png)

#### 3.二维数组中最大的数就是最长子序列

根据计算规则，可以倒推出最长二位子序列为 "BCBA"

### 代码实现



### 参考

- https://zh.wikipedia.org/wiki/最长公共子序列
- https://www.kancloud.cn/digest/pieces-algorithm/163624