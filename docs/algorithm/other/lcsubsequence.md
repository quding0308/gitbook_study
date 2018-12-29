### 最长公共子序列

最长公共子串（Longest Common Substring）与最长公共子序列（Longest Common Subsequence）的区别： 子串要求在原字符串中是连续的，而子序列则只需保持相对顺序一致，并不要求连续。例如X = {a, Q, 1, 1}; Y = {a, 1, 1, d, f}那么，{a, 1, 1}是X和Y的最长公共子序列。{1, 1} 是X和Y的最长公共子字符串。


### 思路

1. 最长公共子序列问题存在最优子结构：这个问题可以分解成更小，更简单的“子问题”，这个子问题可以分成更多的子问题
2. 最长公共子序列问题的子问题的解是可以重复使用的，也就是说，更高级别的子问题通常会重用低级子问题的解。

拥有这个两个属性的问题可以使用动态规划算法来解决，这样子问题的解就可以被储存起来，而不用重复计算。


**求 "ABCBDAB" 与 "BDCABA" 的最长公共子序列**

#### 1.建二维数组
使用一个二维数组存储子问题的结果方便复用，f[i][j]存储X[i]和Y[j]之前的最长公共子序列长度。

![img](/asserts/img/lcsubsequence1.png)

#### 2.计算规则：

![img](/asserts/img/lcsubsequence2.png)


#### 3.二维数组中最大的数就是最长子序列

根据计算规则，可以倒推出最长二位子序列为 "BCBA"

### 代码实现

``` Swift 
// 最长子序列
static func lcs2(str1: String, str2: String) -> String? {
    // 行数 str1.count  列数  str2.count
    var arr = [[Int]](repeating: [Int](repeating: 0, count: str2.count + 1), count: str1.count + 1)
    var maxRow = 0
    var maxColumn = 0
    var max = 0
    
    for i in 1...str1.count {
        for j in 1...str2.count {
            if str1[str1.index(str1.startIndex, offsetBy: i-1)] == str2[str2.index(str2.startIndex, offsetBy: j-1)] {
                arr[i][j] = arr[i-1][j-1] + 1
                
                if max < arr[i][j] {
                    max = arr[i][j]
                    maxRow = i
                    maxColumn = j
                }
            } else {
                if arr[i-1][j] > arr[i][j-1] {
                    arr[i][j] = arr[i-1][j]
                } else {
                    arr[i][j] = arr[i][j-1]
                }
            }
        }
    }
    
    var result: String = ""
    while true {
        if arr[maxRow][maxColumn] > 0 {
            if arr[maxRow][maxColumn] > arr[maxRow-1][maxColumn],
                arr[maxRow][maxColumn] > arr[maxRow][maxColumn-1] {
                result.insert(str1[str1.index(str1.startIndex, offsetBy: maxRow-1)], at: result.startIndex)
                maxRow -= 1
                maxColumn -= 1
            } else {
                if arr[maxRow-1][maxColumn] > arr[maxRow][maxColumn-1] {
                    maxRow -= 1
                } else {
                    maxColumn -= 1
                }
            }
        } else {
            break
        }
    }
    
    return result
}
```

### 参考

- https://zh.wikipedia.org/wiki/最长公共子序列
- https://www.kancloud.cn/digest/pieces-algorithm/163624