## 减小ipa包体积

### 清理 Extension 中的代码和资源

Extension 对应功能很少，但很容易 通过 Pod 引入大量的库 和 资源。

对应的解决方式：

1. 使用动态库，在 ipa中，framework 只保留一份
2. 引用少量的代码，可以考虑单独把用到的类拆分出来使用 

### 清理资源



### 清理代码


