## CSS
Cascading Style Sheet 样式描述语言

cascade 瀑布；级联；

从内容中分离样式，有助于复用，更容易维护，同样的内容可以使用不同的样式。

### 使用：
```
<link rel="stylesheet" href="style1.css">
```

一条CSS规则：

```
selector {  // 花括号中的部分为声明
    property：value;
    property: value;
}
```

### 如何工作


### 层叠 和 继承


#### 层叠
1. 浏览器对HTML元素定义的默认样式
2. 开发者定义的样式
    1. 外联样式   style.css 
    2. 内联样式   在页面的头部定义，只在本页面生效
    3. 行内样式   定义在特定元素上

#### 继承


### 选择器 Selectors

#### tag selector(type selector)

```
body{
    background-color: lightgray;
}

p{
    color: blue;
    text-decoration: underline;
}
```

#### class selector

通过设置元素的 class 属性，可以为元素指定类名。类名由开发者自己指定。 文档中的多个元素可以拥有同一个类名。

```
.title {    // 以 . 开头声明
    color: yellow;
}


// html
class selector 比 tag selector 优先级更高 
<p class="title">p2</p>
```

#### id selector
通过设置元素的 id 属性为该元素制定ID。ID名由开发者指定。每个ID在文档中必须是唯一的。

```
#myname {   // 以 # 开头声明
    color: purple;
}

// html
<p id="myname">p3</p>

// id 比 class 优先级更高
<p class="title" id="myname">p3</p>

```

#### Pseudo-classes selector
CSS伪类（pseudo-class）是加在选择器后面的用来指定元素状态的关键字。比如，:hover 会在鼠标悬停在选中元素上时应用相应的样式。

```
.title:hover { 
    color: yellow;
}
a {
    color: red;
}
a:visited {
    color: orange;
}
```

伪类列表：
```
:link       // link 没有访问过
:visited    // link 已访问过
:active     // 被激活的时候
:hover      // 鼠标停留
:focus      // link 被选中的时候
:first-child    // 第一个元素
:nth-child  // 子元素中，按照位置先后顺序排序，第 n 个元素
:nth-last-child
:nth-of-type
:first-of-type
:last-of-type
:empty
:target
:checked
:enabled
:disabled

参考：https://developer.mozilla.org/zh-CN/docs/Web/CSS/:first-child
```

#### 基于关系的选择器

```
// 后代选择器
A E     
元素A的任一后代元素E

// 子选择器
A > E
元素A的任一子元素E(E必须紧挨着A)

// 相邻兄弟选择器
B + E
元素B的任一下一个兄弟元素E(第一个兄弟元素如果是E，则起作用)  
B + *   元素B的下一个兄弟元素 

// 通用兄弟选择器
B ~ E
元素B之后的所有类型为E的兄弟元素

B ~ *  表示 元素B之后的所有兄弟元素
```

demo：
``` css
// id 为data-table-1，table 中每行的第一个元素 为 bolder；第二个元素使用等宽字体。 
#data-table-1 td:first-child {font-weight: bolder;}
#data-table-1 td:first-child + td {font-family: monospace;}


a.homepage:hover, a.homepage:focus, a.homepage:active {
  background-color: #666;
}

// 使用CSS 创建下了菜单
div.menu-bar ul ul {
    display: none;
}
div.menu-bar ul:hover ul {
    display: block;
}
```

### 框属性



### 文字样式

``` css
.class-font {
    color: red;
    font-family: -apple-system;
    
    /* 1em 等于 当前元素的父元素上设置的字体大小 */
    font-size: 2.5em;   
    
    /* font-style: normal; */
    font-style: italic;
    
    /* font-weight: normal; */
    font-weight: bold;

    /* text-decoration: none; */
    /* text-decoration: underline; */
    /* text-decoration: overline; */
    text-decoration: line-through;

    /* text-transform: none; */
    /* text-transform: uppercase; */
    /* text-transform: lowercase; */
    text-transform: capitalize;

    /* 水平偏移 垂直偏移 模糊半径 阴影颜色 */
    text-shadow: 4px 4px 5px red;

    /* 文本布局 */
    /* 对齐方式 */
    /* text-align: left; */
    /* text-align: right; */
    /* text-align: center; */
    text-align: justify;

    /* 行高 2.5为乘数 */
    line-height: 2.5;

    /* 字间距 */
    letter-spacing: 10px;

    /* 单词间距 */
    word-spacing: 50px;
} 
```


### 动画 Animation

参考：https://developer.mozilla.org/zh-CN/docs/Web/CSS/CSS_Animations/Using_CSS_animations

动画 从一个CSS样式转换到另一个CSS样式。

一个动画包括：

- 动画的样式规则
- 动画开始、结束、中间时刻的帧

``` css
p {
    animation-name: slidein;
    animation-duration: 3s;
    animation-delay: 5s;
    animation-iteration-count: infinite;
    animation-direction: alternate;
}

@keyframes slidein {
    from {
        margin-left: 100%;
        width: 300%;
    }

    75% {
        font-size: 300%;
        margin-left: 25%;
        width: 150%;
    }

    to {
        margin-left: 0%;
        width: 100%;
    }
}
```

### CSS Grid and Flexbox layout

参考：
- https://developer.mozilla.org/zh-CN/docs/Web/CSS/CSS_Grid_Layout
- https://developer.mozilla.org/zh-CN/docs/Web/CSS/CSS_Grid_Layout/Relationship_of_Grid_Layout

网格布局和弹性布局的区别：

Flexbox 是一维布局（沿横向或纵向）
Grid 是二维布局（同时沿横向和纵向）

### Flexbox

https://developer.mozilla.org/zh-CN/docs/Web/CSS/CSS_Flexible_Box_Layout


### flex-flow、flex-direction、flex-wrap(container属性，对子元素生效)
``` css
指定了内部子元素布局的主轴方向
/* The direction text is laid out in a line */
flex-direction: row;
/* Like <row>, but reversed */
flex-direction: row-reverse;
/* The direction in which lines of text are stacked */
flex-direction: column;
/* Like <column>, but reversed */
flex-direction: column-reverse;
```

flex-wrap
``` css
指定了内部元素单行显示还是多行显示，是否允许换行

取值：
flex-wrap: nowrap // default value
flex-wrap: wrap
flex-wrap: wrap-reverse
```

flex-flow 
``` css
flex-flow 是 flex-direction 和 flex-wrap 的简写。

flex-flow: row nowrap   // default value

flex-flow: wrap
flex-flow: column wrap-reverse;
```

### align-items (container属性，对子元素生效)
``` css
设置块中的对齐方式。
用于设置让每一单行的容器剧中，而不是整个容器。

对所有直接子节点的 align-self 统一设置。

设置 Flex 在另一个方向的对齐方式。

align-items: normal;
align-items: stretch;

align-items: center; // 元素在侧轴居中
align-items: flex-start;    // 元素向侧轴起点对齐
align-items: flex-end;  // 元素向侧轴终点对齐
align-items: baseline;
```

### justify-content (container属性，对子元素生效)

``` css 
定义了在主轴方向，如何分配元素直接的空间。
只适用于 多行 flex容器。

使用前提：所有弹性元素的 flex-glow 等于0，才生效。（如果存在至少一个弹性元素，则会自动占满空间）

注意：如果没有主动设置 flex，此时 flex 默认为：flex: inherit inherit auto，则 justify-content 生效

```

align-content 与 align-items 的区别：
https://blog.csdn.net/sinat_27088253/article/details/51532992

### align-content (container属性，对子元素生效)

``` css
定义了侧轴方向，如何分配控件
```

### flex、flex-grow、flex-shrink、flex-basis
flex
``` css
flex: 1 1 20px;
三个参数对应：
    flex-grow   拉伸因子(按百分比计算 default 0)
    flex-shrink 收缩因子（按百分比计算 default 1）
    flex-basis  指定了flex元素在主轴方向的初始大小(default auto)

flex: auto 等价于 flex: 1 1 auto
根据自身宽高设置尺寸，会伸长或缩短自身以适应容器

flex: initial 等价于 flex: 0 1 auto
默认值。根据自身宽高设置尺寸，会缩短自身以适应容器，但不会伸长

flex: none 等价于 flex: 0 0 auto
根据自身宽高设置尺寸，不会伸长或缩短来适应容器，完全是非弹性的。

flex 属性可以指定1个，2个或3个值。

flex: 2 设置了 flex-grow 等价于 flex: 2 1 auto

flex: 30px 设置了 flex-basis 等价于  flex: 1 1 30px

flex: 2 30px 等价于 flex: 2 1 30px

flex: 2 2 等价于 flex: 2 2 auto
```

### align-self

``` css

align-self 设置当前flex 元素的对齐方式，会覆盖 container 设置的 align-items 的值

```

### order 
规定了 弹性容器中的可伸缩项目在布局时的顺序。具有相同order的元素按代码顺序布局

```
default value 0
```



### 参考
- https://developer.mozilla.org/zh-CN/docs/Web/CSS/Reference