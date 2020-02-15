
# CPU渲染

## CPU 渲染做的事(2+2+2)：

* 对象创建、调整、销毁
* 布局计算 Autolayout
* 文本的宽高计算
* 文本渲染
* 图片的解码
* 绘制 drawRect CG开头的绘制

## 优化思路：

1. 减少 主线程中 执行的任务
   1. 跟渲染不相关的任务、耗时任务 放到子线程执行
   2. 把图片放到 Assert 中，提升图片解码效率(解压缩时，CPU 峰值至少能降低 3倍)
2. UI 渲染相关的计算结果，缓存复用
   1. tableView 的高度 缓存复用（fd）
   2. 富文本 AttributedString 缓存复用
   3. 使用 Diff 算法，减少 tableView 的刷新工作量
3. 渲染中的 需要做的部分工作 可以放到子线程中执行
   1. YYAsyncLayer
   2. AsyncDisplayKit
4. 只关注当前显示的UI，停止屏幕之外的UI刷新
   1. 避免离屏渲染 
5. 当页面滚动时，减少渲染的工作
   1. tableView减速或停止时，再刷新当前屏幕的UI(VVTableView)

### 懒加载

1. 控件初始化 view创建消耗性能，使用懒加载，创建任务分开
2. 直接使用代码创建会比storyboard创建更快
3. 尽量使用轻量的控件。例如 layer代替view

### 尽量减少主线程中的工作，放到子线程执行

iPhone的CPU目前都是多核(A10 4核，A11 6核，A12 6核)。

而主线程只能在一个核上跑，在App卡顿时，其他核往往无事可做。

一般情况下，由于主线程承担了绝大部分的工作，仅仅是把主线程的任务转移一部分给其他线程进行异步处理，就可以马上享受到并发带来的性能提升。

### Autolayout 性能瓶颈

自动布局是在主线程执行的。可以考虑使用 frame 布局

### 布局计算 调整对象层次和布局
    
视图布局的计算比较消耗cpu，可以使用缓存减少计算，以及不要频繁的计算和调整

### 子线程绘制

Core Graphics 使用 CPU 绘制，渲染成 bitmap , bitmap 传递给 GPU 继续处理。

优化：Core Graphics 可以异步绘制，绘制完成后，显示的时候放回主线程。

``` Swift
dispatch_async(backgroundQueue, ^{
    CGContextRef ctx = CGBitmapContextCreate(...);
    // draw in context...
    CGImageRef img = CGBitmapContextCreateImage(ctx);
    CFRelease(ctx);
    dispatch_async(mainQueue, ^{
        layer.contents = img;
    });
});
```

### 多使用缓存，减少计算

1. 更新时，只更新有变化的内容 (RXDataSource的思路)

#### 图片渲染

在子线程中加载图片，把图片绘制出来再使用。

### 文字渲染 调整对象文本计算

``` Swift
文本的宽高计算，做缓存，
    在后台线程绘制
    用 [NSAttributedString boundingRectWithSize:options:context:] 来计算文本宽高，用 -[NSAttributedString drawWithRect:options:context:] 来绘制文本，记住放到后台线程进行以避免阻塞主线程。
```

### 异步渲染layer

YYAsyncLayer

### 滑动时 省去中间过程的计算，直接计算目标区域的cell
