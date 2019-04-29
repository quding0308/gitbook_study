## CALayer 子类

CATiledLayer

CATiledLayer为载入大图造成的性能问题提供了一个解决方案：将大图分解成小片然后将他们单独按需载入。

把大图片 切分成小图片。然后 按需加载 小图片。

CAScrollLayer

CATextLayer

使用 Core Text 绘制文本。

具体使用跟 UILabel 类似 
```
textLayer.string = text;

textLayer.contentsScale = [UIScreen mainScreen].scale;
```

CAOpenGLLayer

CAEmitterLayer

高性能粒子引擎，用于创建 烟雾，火，雨等效果

CAGradientLayer

生成两种或更多颜色平滑渐变的layer

CAShapeLayer

通过矢量图形来绘制图层子类

CATransformLayer 是一个layer group，需要 addSubLayer

AVPlayerLayer

播放 视频的layer


https://blog.csdn.net/lxl_815520/article/details/51889674

### 模型

layer 内部维护着三分 layer tree,
- presentLayer Tree(动画树),
- modeLayer Tree(模型树)
- Render Tree (渲染树)

在做 iOS动画的时候，我们修改动画的属性，在动画的其实是 Layer 的 presentLayer的属性值,而最终展示在界面上的其实是提供 View的 modelLayer

在 View显示的时候，UIView 做为 Layer 的 CALayerDelegate,View 的显示内容由内部的 CALayer 的 display

每个 UIView 内部都有一个 CALayer 在背后提供内容的绘制和显示，并且 UIView 的尺寸样式都由内部的 Layer 所提供。两者都有树状层级结构，layer 内部有 SubLayers，View 内部有 SubViews.但是 Layer 比 View 多了个AnchorPoint
