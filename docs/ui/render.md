<!-- ![image](../gitbook/images/sort1.jpg) -->

### render

#### CPU、GPU、显示器如何一起工作

![](http://pc5ouzvhg.bkt.clouddn.com/A22332C0-4155-4825-B2CD-CB21354BD41F.jpg)

1. CPU计算好显示的内容提交给GPU
2. GPU渲染完后将渲染结果放入帧缓冲区
3. 视频控制器 按照HSync 和 VSync信号读取帧缓冲区数据，传递给显示器

#### 双缓冲区机制

帧缓冲区有两个：Buffer1 + Buffer2

双缓冲区要解决的问题：

GPU渲染好一帧后就更新缓冲区(视频控制器指向了另一个缓冲区)。但此时显示器可能只刷新了半屏幕的数据，更新缓存区后，会从新的缓冲区读取数据，会导致一个屏幕内的数据来源于两个缓冲区，导致画面撕裂。

GPU的垂直同步机制（V-Sync机制）解决双缓冲区的问题：
1. GPU渲染好一帧放入一个缓冲区，由视频控制器读取。
2. 当显示器把Buffer1的内容绘制到屏幕后，会发送VSync信号。视频控制器会从Buffer1切换到Buffer2，继续绘制Buffer2的内容。当App进程收到VSync信号后，开始绘制下一帧内容到Buffer1。

#### 绘制一帧的过程

如果在一个VSync周期内 CPU + GPU 渲染没有结束，则会丢弃这一帧的绘制结果，重新绘制下一帧。此时就发生了 “掉帧”

CPU渲染 -> GPU渲染 -> 结果放到buffer中

![](http://pc5ouzvhg.bkt.clouddn.com/1608422C-20C3-44DF-8604-250EC41C940E.jpg)

![](http://pc5ouzvhg.bkt.clouddn.com/E85C9EC1-A4F4-48E2-AE95-3DDD0D7356BF.jpg)

显示器的VSync信号到来后，iOS系统会通过CADisplayLink机制通知App

App的主线程开始在 CPU 中计算显示内容，比如视图的创建、布局计算、图片解码、文本绘制等。随后 CPU 会将计算好的内容提交到 GPU 去，由 GPU 进行变换、合成、渲染。随后 GPU 会把渲染结果提交到帧缓冲区Buffer1。当下一次 VSync 信号到来时，会Buffer1的内容显示到屏幕上，在Buffer2中渲染下一帧的内容。

#### iOS中卡顿原因：

如果在一个VSync周期内，下一帧的内容没有渲染到Buffer中，则这一帧就会被丢弃，显示器会保留之前的内容不变。给用户的感觉就是 “卡顿”

在一帧的渲染过程中，不管CPU 和 GPU 哪个阻碍了显示流程，都会造成卡顿。所以需要分别考虑优化CPU和GPU的渲染过程。

### CPU渲染

#### CPU消耗的资源(2+2+2)：

* 对象创建、调整、销毁
* 布局计算 Autolayout
* 文本的宽高计算
* 文本渲染
* 图片的解码
* 绘制 drawRect CG开头的绘制

### GPU消耗：

* 纹理的渲染
* 视图的混合
* 图形的生成

### 大概优化思路

- 尽量减少主线程中的工作，放到子线程执行
- 多使用缓存，减少计算
- 更新时，只更新有变化的内容 (RXDataSource的思路)
  
### 参考：
- 重点的UI相关
- 找lt 发 resume，确定 几个选项
- Autolayout 渲染优化：https://juejin.im/post/5bd5a546f265da0af033cee6
- https://blog.ibireme.com/2015/11/12/smooth_user_interfaces_for_ios/#32





