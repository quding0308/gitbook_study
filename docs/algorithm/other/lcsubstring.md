### 最长公共子串


最长公共子串（Longest Common Substring）与最长公共子序列（Longest Common Subsequence）的区别： 子串要求在原字符串中是连续的，而子序列则只需保持相对顺序一致，并不要求连续。例如X = {a, Q, 1, 1}; Y = {a, 1, 1, d, f}那么，{a, 1, 1}是X和Y的最长公共子序列。{1, 1} 是X和Y的最长公共子字符串。


### 思路

1. 最长公共子串存在最优子结构：这个问题可以分解成更小，更简单的“子问题”
2. 最长公共子串问题的子问题的解是可以重复使用的，也就是说，更高级别的子问题通常会重用低级子问题的解。

拥有这个两个属性的问题可以使用动态规划算法来解决，这样子问题的解就可以被储存起来，而不用重复计算。

**求 "ABCBDABA" 与 "BDCABA" 的最长公共子串**

#### 1.建二维数组
使用一个二维数组存储子问题的结果方便复用，f[i][j]存储X[i]和Y[j]之前的最长公共子串长度。

![img](/asserts/img/lcsubsubstring1.png)


#### 2.计算规则：

```
if x[i] == y[j] {
    c[i,y] = c[i-1,j-1] + 1
} else {
    c[i,y] = 0
}

```

#### 3.二维数组中最大的数就是最长子串

根据计算规则，可以倒推出最长二位子序列为 "ABA"

### 代码实现

``` Swift
// 最长子串
static func lcs1(str1: String, str2: String) -> String? {
    // 行数 str1.count  列数  str2.count
    var arr = [[Int]](repeating: [Int](repeating: 0, count: str2.count+1), count: str1.count+1)
    var maxRow = 0
    var maxColumn = 0
    var max = 0
    
    for i in 1...str1.count {
        for j in 1...str2.count {
            if str1[str1.index(str1.startIndex, offsetBy: i-1)] == str2[str2.index(str2.startIndex, offsetBy: j-1)] {
                arr[i][j] = arr[i - 1][j - 1] + 1
                
                if max < arr[i][j] {
                    max = arr[i][j]
                    maxRow = i
                    maxColumn = j
                }
            } else {
                arr[i][j] = 0
            }
        }
    }
    
    var result: String = ""
    while true {
        if arr[maxRow][maxColumn] > 0 {
            result.insert(str1[str1.index(str1.startIndex, offsetBy: maxRow-1)], at: result.startIndex)
            
            maxRow -= 1
            maxColumn -= 1
        } else {
            break
        }
    }
    
    return result
}
```