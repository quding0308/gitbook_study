# GPU 相关

问题：

- 离屏渲染 是在 cpu 还是 gpu 阶段？
- 如何避免？
- 一个像素是如何绘制到屏幕上去的
- opaque 处理

## 图形流水线 Graphic Pipeline

对于图像进行实时渲染的过程，可以被分解成下面这样 5 个步骤：

* 顶点处理（Vertex Processing）
* 图元处理（Primitive Processing）
* 栅格化（Rasterization）
* 片段处理（Fragment Processing）
* 像素操作（Pixel Operations）

### 顶点处理

在三维图形中，构成多边形建模的每个多边形有多个顶点 Vertex 。Vertex 有一个在三维空间的坐标，但是屏幕是二维的。当确定当前视角时，需要把三维空间的坐标转换为屏幕这个二维空间的坐标。这样的转换操作，就是顶点处理。
每个顶点位置的转换，互相没有依赖，可以并行计算。

### 图元处理

把顶点处理完之后的顶点连接起来，变成多边形。然后把不在屏幕里面的内容去掉（剔除和裁剪操作）

### 栅格化

把多边形转换为屏幕里面的一个个像素点。
每一个图元都可以独立的进行栅格化操作。

### 片段处理

计算每一个像素的颜色、透明度等信息，给像素上色。
每个片段可以并行、独立进行片段处理。

### 像素操作

把不同的多边形的像素点混合“Blending”到一起。
可能前面的多边形可能是半透明的，那么前后的颜色就要混合在一起变成一个新的颜色；或者前面的多边形遮挡住了后面的多边形，那么我们只要显示前面多边形的颜色就好了。

下面是4个步骤：

![img](/asserts/img/gpu1.png)


## 优化思路

* 减少离屏渲染，少用 mask、
* 使用 opaque 属性，减少 blend 的工作。去掉透明通道。
* 减少像素对齐的操作
* 尽量使用 resizable 的图片，尽量减小图片尺寸。CPU 加载解压更快，占用内存更少。从 CPU 的缓存发送到 GPU 的缓存更快速


## 离屏渲染

### On Screen Render

当前屏幕渲染。指GPU渲染的操作是在屏幕缓冲区中进行。

### Off Screen Render

离屏渲染，指 GPU 渲染阶段在屏幕缓冲区之外新开辟一个缓冲区进行渲染。

### 触发离屏渲染

- masks 遮罩
- allowsGroupOpacity
- cornerRadius + maskToBounds
- shadows 阴影
- edge antialiasing 抗锯齿


### 为什么会有离屏渲染

上面的操作在进行图层的合成之前需要先进行计算，对单个图层的像素进行计算(即对重叠视图的每个像素的 R，G，B，A 值进行重计算)单图层的像素确定后在合并图层。

### shouldRasterize（光栅化）

When the value of this property is true, the layer is rendered as a bitmap in its local coordinate space and then composited to the destination with any other content. Shadow effects and any filters in the filters property are rasterized and included in the bitmap. 

### 参考
- http://www.10tiao.com/html/585/201803/2654061295/1.html
- https://www.jianshu.com/p/ca51c9d3575b
- https://www.objc.io/issues/3-views/moving-pixels-onto-the-screen/
- https://objccn.io/issue-3-1/
