<!-- ![image](../gitbook/images/sort1.jpg) -->

### render


### CPU渲染

view创建 -> 创建好bitmap后，赋值给layer.content

view缓冲区创建（cpu）

view内容绘制，drawRect（cpu）

- 图片解压

- 控件初始化 view创建消耗性能
1.使用懒加载，创建任务分开
2.直接使用代码创建会比storyboard创建更快
3.尽量使用轻量的控件。例如 layer代替view

- 文字渲染 调整对象文本计算
    文本的宽高计算，做缓存，
    在后台线程绘制
    优化方案：用 [NSAttributedString boundingRectWithSize:options:context:] 来计算文本宽高，用 -[NSAttributedString drawWithRect:options:context:] 来绘制文本，记住放到后台线程进行以避免阻塞主线程。


- 布局计算 调整对象层次和布局
    视图布局的计算比较消耗cpu，可以使用缓存减少计算，以及不要频繁的计算和调整



### 参考：
- 1
- 2




