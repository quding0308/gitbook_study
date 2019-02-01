### JavaScript



在 JavaScript 中，对象的状态和行为都被抽象为属性。方法是 Function 类型的对象

JavaScript 中对象独有的特色是：对象具有高度的动态性，在运行时可以为对象添加状态和行为。

``` JavaScript
    var o = { a: 1 };
    o.b = 2;
    console.log(o.a, o.b); //1 2
```


### JavaScript 对象的属性

#### 数据属性

数据属性的特征：

- value 属性值
- writable 属性是否被赋值
- enumerable 决定 for in 是否可以枚举该属性
- configurable 决定书写是否被删除或改变


``` JavaScript
    var o = { a: 1 };
    o.b = 2;
    //a 和 b 皆为数据属性
    Object.getOwnPropertyDescriptor(o, "a") // {value: 1, writable: true, enumerable: true, configurable: true}
    Object.getOwnPropertyDescriptor(o, "b") // {value: 2, writable: true, enumerable: true, configurable: true}
```

#### 访问器属性

访问器属性的特征：

- getter 取属性值是被调用  默认 undefined
- setter 设置属性值是被调用  默认 undefined
- enumerable 决定 for in 是否可以枚举该属性
- configurable 决定书写是否被删除或改变

``` JavaScript
    var o = { get a() { return 1 } };
    console.log(o.a); // 1
```



### 参考
- [https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Inheritance_and_the_prototype_chain](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Inheritance_and_the_prototype_chain)
- [http://www.ruanyifeng.com/blog/2011/06/designing_ideas_of_inheritance_mechanism_in_javascript.html](http://www.ruanyifeng.com/blog/2011/06/designing_ideas_of_inheritance_mechanism_in_javascript.html)