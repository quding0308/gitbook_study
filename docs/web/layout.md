## layout

### 常见布局思路

#### 宽度自适应，高度写死

使用 flex 布局，宽度使用百分比布局。高度写死 固定px。

缺点：不同屏幕，会拉伸 UI

#### 固定宽度

宽度写死，在大屏幕上会左右留空白


#### 使用 viewport 进行缩放

以 320 宽度为基准，进行缩放，最大缩放为 320*1.3 = 416，基本缩放到416都就可以兼容iphone6 plus的屏幕了

```
<meta name="viewport" content="width=320,maximum-scale=1.3,user-scalable=no">
```

#### 使用 rem

能够等比例适配所有屏幕

指定根元素 html font-size，其他元素使用 rem 为单位布局。

```
html {
    font-size: 20px;
}

```

rem 与 em 的区别：

em 相对于当前对象内文本的字体尺寸

rem 相对于根元素 html 的文本的字体尺寸


参考：

- http://caibaojian.com/web-app-rem.html
- https://juejin.im/post/5b41bf63f265da0f8b2f9656
- https://www.runoob.com/w3cnote/px-em-rem-different.html


### 宽度、高度

#### devicePixelRatio

获取屏幕 物理像素分辨率 与 CSS像素分辨率 的比值

```
在 iPhone 8， dpr = 2
在 iPhone 8 plus， dpr = 3
var dpr = window.devicePixelRatio;

在 iOS 中获取方式：
let scale = UIScreen.main.scale
```

#### document.body.clientWidth 与 document.body.clientHeight

获取展示内容的宽高 (375, 423)，类比 iOS 中 scrollView.contentSize

如果内容可以上下滚动，则获取的是 scrollView.contentSize.height

```
<meta name="viewport" content="width=device-width,initial-scale=1.0">

let width = window.document.body.clientWidth
let height = window.document.body.clientHeight
```

#### window.innerWidth 与 window.innerWidth

可视区域的高度

在 safari 中会去掉 status bar、navigation bar、toobar 计算高度。

在 WKWebView 中需要根据 vc.edgesForExtendedLayout 来 确定是否计算 status bar、navigation bar 的高度

```
let width = window.innerWidth
let height = window.innerHeight
```

#### window.outerWidth 与 window.outerWidth

可视区域的高度，屏幕的真实宽高

```
let width = window.innerWidth
let height = window.innerHeight
```

#### scrollTop 与 scrollLeft

设置滚动

```
window.document.body.scrollTop = 300
```