## less 的使用

### 概述

less 中文文档：

https://less.bootcss.com/features/

Less （Leaner Style Sheets 的缩写） 是一门向后兼容的 CSS 扩展语言，是 CSS 的超集。

在 CSS 的基础上，增加了一些新的特性，使 CSS 写起来更高效，更令人愉悦。

### 特性

通过 Variables、Maps、Mixins 可以抽离出通用的 rule-set ，方便复用。

通过 importing、Nesting、Namespace 可以让代码更模块化，结构更清晰，同时也可以避免全局污染。

通过 Function、Operation 可以让计算更灵活，属性间的依赖可以直接通过函数或     
 Operation 来计算。

#### 变量 Variables

``` css
@width: 10px;
@height: @width + 10px;

#header {
    width: @width;
    height: @height;
}
```

#### 混合 Mixins

类似继承或组合的概念，定义一个 rule-set ，然后在另一个 rule-set 中直接使用之前定义的的 rule-set

``` css
.bordered {
    border-top: dotted 1px black;
    border-bottom: solid 2px black;
}

.btn1 {
    width: @width;
    height: @height;

    .bordered()
}
```

#### 嵌套 Nesting

``` css
#content {
    background-color: lightgrey;
    button {
        background-color: lightgoldenrodyellow;
    }
    .btn1-wraper {
        button {
            color: red;
        }
    }
    .btn2-wraper {
        button {
            color: blueviolet;
        }
    }
}
```

#### 导入 importing

// 可以
```
@import "./less_study2";
@import "./less_study2.css";
```

#### 作用域

使用就近的 Variable

``` css
@var: red;

#page {
  @var: white;
  #header {
    color: @var; // white
  }
}
```

#### Maps

定义类似 Map 的数据，在 less 代码中使用

``` css
#colors() {
    primary: red;
    secondry: green;
}

.button {

}
```

#### Escaping

可以理解为反斜杠相同作用，直接替换文本

``` css
/* 旧的写法 */
/* @min768: ~"(min-width: 768px)"; */
@min768: (min-width: 768px);
.element {
  @media @min768 {
    font-size: 1.2rem;
  }
}

/* 会生成 CSS ： */
@media (min-width: 768px) {
  .element {
    font-size: 1.2rem;
  }
}
```

#### Namespace

类比 c++中的 namespace 命名空间，在这个 namespace 中定义的 Variable、Map等，不会被污染。使用时，namespace.selector 这种方式即可调用

``` css
#qd() {
    .bordered {
        border-top: dotted 1px black;   
        border-bottom: solid 2px black;
    }
}

.btn1 {
    width: @width;
    height: @height;

    #qd.bordered()
}
```

#### 运算 Operations

+ - * / 基本运算可以用于 数字、颜色、变量。

``` css
// example with variables
@base: 5%;
@filler: @base * 2; // result is 10%
@other: @base + @filler; // result is 15%
```

#### 函数 Function

less 内置了很多函数，参考：https://less.bootcss.com/functions/

```
@width: 0.5;

@width_percentage: percentage(@width); // returns `50%`

// 颜色
color("#aaa");

image-width("file.png");
image-height("file.png");
image-size("file.png");

data-uri('../data/image.jpg');
// 会生成base64的 output
url('data:image/jpeg;base64,bm90IGFjdHVhbGx5IGEganBlZyBmaWxlCg==');


// String
escape('a=1') 
// url encode 编码
a%3D1




```

##### 自定义函数

``` css
// px转rem
.px2rem(@name, @px){
    @{name}: @px / 50 * 1rem;
}

.btn {
    .px2rem(height, 100);
}
// 生成为：
.btn {
    height: 2em;
}
```





