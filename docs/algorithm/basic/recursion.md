### 递归

递归是一种广泛使用的编程技巧。

DFS、前中后序二叉树遍历 可用 递归实现。

如果一个问题 A 可以分解为若干子问题 B、C、D，你可以假设子问题 B、C、D 已经解决，在此基础上思考如何解决问题 A。而且，你只需要思考问题 A 与子问题 B、C、D 两层之间的关系即可，不需要一层一层往下思考子问题与子子问题，子子问题与子子子问题之间的关系。屏蔽掉递归细节，这样子理解起来就简单多了

编写递归代码的关键是，只要遇到递归，我们就把它抽象成一个递推公式，不用想一层层的调用关系，不要试图用人脑去分解递归的每个步骤。

#### 递归需要满足3个条件：

1. 一个问题的解可以分解几个子问题的解（子问题就是数据规模更小的问题）
2. 这个问题与分解之后的子问题，除了数据规模不同，求解思路完全一样
3. 存在递归终止条件。终止条件，用于终止无限循环

#### 如何编写递归代码？

1. 找到递归公式
2. 找到终止条件

所有的递归问题 都可用递归公式表示。把递归公式转化为代码。

### 注意问题

1. 递归代码要警惕堆栈溢出
2. 递归代码要警惕重复计算

### 参考

- https://time.geekbang.org/column/article/41440