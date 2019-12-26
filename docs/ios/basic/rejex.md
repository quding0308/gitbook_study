### 正则表达式 Regular Expression

用途：

- 字符串搜索
- 字符串替换


#### 限定符
``` Swift
^ 匹配字符串的开始位置
$ 匹配字符串的结束位置

* 匹配前面的子表达式0次或多次 等价于 {0,}
+ 匹配前面的子表达式1次或多次 等价于 {1,}
？ 匹配前面的子表达式0次或1次 等价于 {0,1}

{n} 匹配确定的n次
{n,} 至少n次
{n,m} n到m次

[xyz] 匹配包含的任一个字符   
[^xyz] 匹配除xyz外的任一个字符
[a-z]
[^a-z] 匹配a-z之外的任一字符

参考：https://zh.wikipedia.org/wiki/%E6%AD%A3%E5%88%99%E8%A1%A8%E8%BE%BE%E5%BC%8F
```

#### 常用的正则
``` Swift
^[0-9]*$ 字符串只包括0-9的数字  包括空字符串
^[0-9]+$ 字符串只包括0-9的数字  不包括空字符串
^[A-Za-z]*$ 是否为大小写字母，包括空字符串

\\d 是否为数字  例如  11.2   3.14   444
```

#### Swift中正则的使用
``` Swift
fileprivate func isPureNumber(_ string: String) -> Bool {
    return textRegex(content: string, pattern: "^[0-9]*$")
}

fileprivate func isPureLetter(_ string: String) -> Bool {
    return textRegex(content: string, pattern: "^[A-Za-z]*$")
}

fileprivate func isPureSymbol(_ string: String) -> Bool {
    //        let regex: NSPredicate = NSPredicate(format: "SELF MATCHES %@", "^[~\\^{}[]()<><>_\\$@#%&/\\|=-+*`‘”;:\\.,!?]*$")
    
    return !hasLetter(string) && !hasNumber(string)
}

fileprivate func isNumberAndLetterAndSymbol(_ string: String) -> Bool {
    return hasNumber(string) && hasLetter(string) && !isNumberAndLetter(string)
}

private func isNumberAndLetter(_ string: String) -> Bool {
    let regex: NSPredicate = NSPredicate(format: "SELF MATCHES %@", "^[0-9A-Za-z]*$")
    return regex.evaluate(with: string)
}

private func hasNumber(_ string: String) -> Bool {
    return textRegex(content: string, pattern: "[0-9]")
}

private func hasLetter(_ string: String) -> Bool {
    return textRegex(content: string, pattern: "[A-Za-z]")
}

private func textRegex(content: String, pattern: String) -> Bool{
    do {
        // 定义规则
        // let pattern = "ben"
        
        // 创建正则表达式对象
        let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
        
        // 开始匹配
        let result = regex.matches(in: content, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, content.count))
        
        //            print(result.count)
        if  result.count > 0 {
            return true
        }
    } catch {
        print(error)
    }
    
    return false
}
```
