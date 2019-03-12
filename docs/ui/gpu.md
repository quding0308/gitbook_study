

### 离屏渲染

#### On Screen Render

当前屏幕渲染。指GPU渲染的操作是在屏幕缓冲区中进行。

#### Off Screen Render

离屏渲染。指GPU渲染操作 在屏幕缓冲区之外新开辟一个缓冲区进行渲染。


````
注意：Core Graphics 使用CPU绘制，渲染成bitmap后，交由 GPU 显示。

优化：Core Graphics 可以异步绘制，绘制完成后，显示的时候放回主线程。


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

#### 触发离屏渲染

- shouldRasterize（光栅化）设置为 YES
- masks 遮罩
- shadows 阴影
- edge antialiasing 抗锯齿
- group opacity 半透明
- 设置圆角
- 渐变

```
shouldRasterize（光栅化）

When the value of this property is true, the layer is rendered as a bitmap in its local coordinate space and then composited to the destination with any other content. Shadow effects and any filters in the filters property are rasterized and included in the bitmap. 
```


#### Instruments监测离屏渲染

Instruments的Core Animation工具中有几个和离屏渲染相关的检查选项：

##### Color Offscreen-Rendered Yellow
开启后会把那些需要离屏渲染的图层高亮成黄色，这就意味着黄色图层可能存在性能问题。

##### Color Hits Green and Misses Red
如果shouldRasterize被设置成YES，对应的渲染结果会被缓存，如果图层是绿色，就表示这些缓存被复用；如果是红色就表示缓存会被重复创建，这就表示该处存在性能问题了。




