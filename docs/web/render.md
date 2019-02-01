## 渲染

建议直接阅读[原文](https://developers.google.com/web/fundamentals/performance/critical-rendering-path/?hl=zh-cn)

浏览器渲染步骤：

1. 处理 HTML 标记并构建 DOM 树。
2. 处理 CSS 标记并构建 CSSOM 树。
3. 将 DOM 与 CSSOM 合并成一个渲染树。
4. 根据渲染树来布局，以计算每个节点的几何信息。
5. 将各个节点绘制到屏幕上。


### 1.构建 DOM 树

``` html
<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <link href="style.css" rel="stylesheet">
    <title>Critical Path</title>
  </head>
  <body>
    <p>Hello <span>web performance</span> students!</p>
    <div><img src="awesome-photo.jpg"></div>
  </body>
</html>
```

![img](/asserts/img/web_render_1.png)


1. 从网络或磁盘读取html文件，根据文件编码转换成字符
2. 根据 html 标准，解析尖括号tag，尖括号内的字符串
3. 词法分析。根据解析的 Tokens ，转换成定义其属性的和规则的对象
4. 构建DOM树。把对象链接在一个树数据结构内，确定整个DOM树结构

### 2.构建 CSSOM 树

``` css
body { font-size: 16px }
p { font-weight: bold }
span { color: red }
p span { display: none }
img { float: right }
```

![img](/asserts/img/web_render_2.png)
![img](/asserts/img/web_render_3.png)

1. 从网络或磁盘读取css文件，根据文件编码转成字符
2. 根据语法规则，解析字符为 Token
3. 根据解析的 Token，生成 Node，每个Node 有自己的属性
4. 构建 CSSOM 树。

### 3.构建渲染树

DOM树 和 CSSOM树合并后形成渲染树。

渲染树只包含可见节点和他们的计算样式。


![img](/asserts/img/web_render_4.png)

1. 从DOM树根节点，遍历每个可见节点
2. 对于每个可见节点，为其寻找CSSOM规则，并应用

```
请注意 visibility: hidden 与 display: none 是不一样的。前者隐藏元素，但元素仍占据着布局空间（即将其渲染成一个空框），而后者 (display: none) 将元素从渲染树中完全移除，元素既不可见，也不是布局的组成部分。
```

### 4.布局layout

根据渲染树 计算每个节点在设备内的确切位置和大小。

布局流程的输出是一个“盒模型”，它会精确地捕获每个元素在视口内的确切位置和尺寸：所有相对测量值都转换为屏幕上的绝对像素。

布局完成后我们知道了 哪些节点可见，他们的计算样式，和 节点在设备上的确切位置和大小。 

### 5.绘制 paint

将渲染树中的每个节点转换成屏幕上的实际像素。这一步通常称为“绘制”或“栅格化”。

## 优化关键渲染路径

**优化关键渲染路径**是优先显示与当前用户操作相关的内容，缩短浏览器渲染的时间

### 阻塞渲染的CSS

CSS 是阻塞渲染的资源。需要将它尽早、尽快地下载到客户端，以便缩短首次渲染的时间。

HTMl 和 CSS 都是阻塞渲染的资源。

默认情况下 CSS 是阻塞渲染的资源，可以通过设置 meida 了行，将一些 CSS 标记为不阻塞渲染

浏览器会下载所有的CSS资源，无论阻塞或不阻塞

```
<link href="style.css" rel="stylesheet">
// 只有在 打印 的时候使用的css，不会阻塞web端渲染
<link href="print.css" rel="stylesheet" media="print">  
// 指定条件下使用的css，不满足条件的话不阻塞渲染
<link href="other.css" rel="stylesheet" media="(min-width: 40em)">
// 竖屏 才使用
<link href="portrait.css" rel="stylesheet" media="orientation:portrait">
```

### 防止 JavaScript 阻塞渲染

JavaScript 脚本在文档的何处插入，就在何处执行。

当 HTML 解析器遇到一个 script 标记时，它会暂停构建 DOM，将控制权移交给 JavaScript 引擎；等 JavaScript 引擎运行完毕，浏览器会从中断的地方恢复 DOM 构建。

Javascript 线程 和 UI 线程不会同时执行，是互斥的。

“优化关键渲染路径”在很大程度上是指了解和优化 HTML、CSS 和 JavaScript 之间的依赖关系谱。

1. JavaScript 可以查询和修改 DOM 与 CSSOM。
2. JavaScript 在 DOM 构建之前，操作 DOM 则找不到元素
3. JavaScript 在 CSSOM 构建之前操作 CSSOM，则浏览器将延迟脚本执行和 DOM 构建，直至其完成 CSSOM 的下载和构建。
4. 当浏览器遇到一个 script 标记时，DOM 构建将暂停，直至脚本完成执行。

优化：

```
// 异步执行 script
<script src="app.js" async></script>

```

### 使用 Navigation Timing API 测量性能

- domLoading 开始解析HTML文档
- domInteractive DOM构建完成
- domContentLoaded DOM 与 CSSOM 构建完成，准备构建渲染树
- domComplete 网页与子资源(包括图片)都就绪
- loadEvent 网页加载最后一步，触发 onload 事件

``` html
<!DOCTYPE html>
<html>
  <head>
    <title>Critical Path: Measure</title>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <link href="style.css" rel="stylesheet">
    <script>
      function measureCRP() {
        var t = window.performance.timing,
          interactive = t.domInteractive - t.domLoading,
          dcl = t.domContentLoadedEventStart - t.domLoading,
          complete = t.domComplete - t.domLoading;
        var stats = document.createElement('p');
        stats.textContent = 'interactive: ' + interactive + 'ms, ' +
            'dcl: ' + dcl + 'ms, complete: ' + complete + 'ms';
        document.body.appendChild(stats);
      }
    </script>
  </head>
  <body onload="measureCRP()">
    <p>Hello <span>web performance</span> students!</p>
    <div><img src="awesome-photo.jpg"></div>
  </body>
</html>
```

参考：https://developers.google.com/web/fundamentals/performance/critical-rendering-path/measure-crp?hl=zh-cn


## 渲染一个页面的demo

``` html
<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <link href="style.css" rel="stylesheet">
  </head>
  <body>
    <p>Hello <span>web performance</span> students!</p>
    <div><img src="awesome-photo.jpg"></div>
    <script src="app.js"></script>
  </body>
</html>
```

渲染流程：

![img](/asserts/img/web_render_5.png)

这个关键渲染路径中，包括：

1. 关键资源： 可能阻止网页首次渲染的资源。3个关键资源
2. 关键路径长度： 获取所有关键资源所需的往返次数或总时间。至少2次请求时间
3. 关键字节。11KB

优化关键渲染路径的步骤：

1. 分析关键资源、字节数、路径长度
2. 最大限度减少关键资源
3. 压缩关键字节数，缩短下载时间(tcp往返次数)
4. 优化关键资源加载顺序，尽早下载所有关键资源，以此缩短关键长度

## 参考
- https://developers.google.com/web/fundamentals/performance/critical-rendering-path/?hl=zh-cn