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

### viewport

手机浏览器是把页面放在一个虚拟的"视口"（viewport）中，通常这个虚拟的 viewport 比屏幕宽，这样就不用把每个网页挤到很小的窗口中（这样会破坏没有针对手机浏览器优化的网页的布局），用户可以通过平移和缩放来看网页的不同部分。

在浏览器窗口css的布局区域，布局视口的宽度限制css布局的宽。为了能在移动设备上正常显示那些为pc端浏览器设计的网站，移动设备上的浏览器都会把自己默认的viewport设为980px或其他值，一般都比移动端浏览器可视区域大很多，所以就会出现浏览器出现横向滚动条的情况

我们可以设置 viewport 的属性，让页面根据手机的实际屏幕宽度来布局。

```
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">

width：控制 viewport 的大小，可以指定的一个值，如 600，或者特殊的值，如 device-width 为设备的宽度（单位为缩放为 100% 时的 CSS 的像素）。
height：和 width 相对应，指定高度。
initial-scale：初始缩放比例，也即是当页面第一次 load 的时候缩放比例。
maximum-scale：允许用户缩放到的最大比例。
minimum-scale：允许用户缩放到的最小比例。
user-scalable：用户是否可以手动缩放。
```

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