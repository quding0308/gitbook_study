## Core Graphics
### Overview 

```
Harness the power of Quartz technology to perform lightweight 2D rendering with high-fidelity output. Handle path-based drawing, antialiased rendering, gradients, images, color management, PDF documents, and more.

充分利用 Quartz 绘图引擎的能力来执行轻量级的 2D渲染操作，并且保证有高保真的输出。
具体包括 path绘制、抗锯齿渲染、渐变绘制、image绘制、颜色管理、PDF渲染等

```

### Context

Context 相当于Android里面的Canvas，使用UIGraphicsGetCurrentContext()获取当前CGContext的引用CGContextRef。我们在每一次的绘制之前都应该保存下原来的状态，待绘制完成后再恢复回原来的状态。所以CGContextSaveGState(ctx);… CGContextRestoreGState(ctx);都应该成对的出现，在他们之间的是绘制UI的代码。

### 绘制生成一个Image

```
/*
    UIGraphicsRendererContext
    NSStringDrawingContext
    UIGraphicsImageRendererContext
*/

- (UIImage *)snapshot {
    UIGraphicsBeginImageContext(CGSizeMake(300, 300));
    [self.grahpicsView drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
//    [self.grahpicsView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    /// 0-1的压缩  0为最大有损压缩 1为最高质量压缩
    NSData *dataJPEG = UIImageJPEGRepresentation(img, 0.5);
    
    // png 格式的图片数据
    NSData *dataPNG = UIImagePNGRepresentation(img);
    
    return img;
}

/*
    UIGraphicsRenderer
    UIGraphicsImageRenderer
    UIGraphicsPDFRenderer
*/
- (void)drawUIRender {
    // 这里可以设置渲染的图片格式
    UIGraphicsImageRenderer *imgRender = [[UIGraphicsImageRenderer alloc] initWithSize:CGSizeMake(200, 200)];
    
    UIImage *image = [imgRender imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull context) {
        [[UIColor darkGrayColor] setStroke];
        [context fillRect:CGRectMake(0, 0, 100, 100)];
    }];
    
    [self.imgView setImage:image];
}

```

### 绘图

```
- (void)drawRect:(CGRect)rect {
// 在 drawRect 中，已经有CGContextRef了，不需要创建
//    CGContextRef context = UIGraphicsGetCurrentContext();

    // fill
    [[UIColor redColor] setFill];
    UIRectFill(CGRectMake(50, 100, 100, 100));
//    UIRectFillUsingBlendMode(CGRectMake(100, 100, 100, 100), kCGBlendModeNormal);
    
    // stroke
    [[UIColor purpleColor] setStroke];
    UIRectFrame(CGRectMake(200, 100, 100, 100));
    
    // Bezier Path
    [[UIColor blackColor] setStroke];
//    UIBezierPath *path1 =[UIBezierPath bezierPathWithRoundedRect:CGRectMake(50, 250, 100, 100) cornerRadius:5];
    UIBezierPath *path1 =[UIBezierPath bezierPathWithRoundedRect:CGRectMake(50, 250, 100, 100)
                                               byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                     cornerRadii:CGSizeMake(20, 20)];   // 圆角的size
    path1.lineWidth = 5;
    [path1 stroke];
    
    [[UIColor blackColor] setFill];
    UIBezierPath *path2 =[UIBezierPath bezierPathWithOvalInRect:CGRectMake(200, 250, 100, 100)];
    [path2 fill];
    
    [[UIColor orangeColor] setStroke];
    UIBezierPath *path3 =[UIBezierPath bezierPath];
    [path3 moveToPoint:CGPointMake(50, 400)];
    [path3 addLineToPoint:CGPointMake(50, 500)];
    [path3 addLineToPoint:CGPointMake(100, 500)];
    [path3 closePath];  // 闭合图形
    [path3 setLineWidth:4];
    [path3 setLineCapStyle:kCGLineCapRound];
    [path3 setLineJoinStyle:kCGLineJoinBevel];
    [path3 stroke];
    self.bezierPath = path3;
    

    [[UIColor orangeColor] setStroke];
    UIBezierPath *path4 =[UIBezierPath bezierPath];
    [path4 addArcWithCenter:CGPointMake(120, 400) radius:30 startAngle:0 endAngle:M_PI clockwise:NO];
    [path4 setLineWidth:4];
    [path4 stroke];
    
    // 随手指动
    [[UIColor redColor] setStroke];
    [[UIColor blackColor] setFill];
    UIBezierPath *path5 =[UIBezierPath bezierPath];
    [path5 addArcWithCenter:self.point radius:10 startAngle:0 endAngle:2 * M_PI clockwise:NO];
    [path5 fill];
    [path5 stroke];
    
    // NSString
    NSDictionary *attrs = @{
      NSForegroundColorAttributeName:[UIColor redColor]
    };
    [@"123你好" drawInRect:CGRectMake(200, 400, 200, 200) withAttributes:attrs];
    
    // image
    UIImage *image = [UIImage imageNamed:@"widget_btn_card_normal"];
    [image drawInRect:CGRectMake(150, 450, 50, 50)];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //
}

// 滑动手势
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint location = [touch locationInView:self];
    self.point = location;
    
    [self setNeedsDisplay];
}

// 点击是否在BezierPath内
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint location = [touch locationInView:self];
    
    if ([self.bezierPath containsPoint:location]) {
        NSLog(@"点击到了 三角形");
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //
}
```

绘图效果：

![img](/asserts/img/coregraphics.jpg)


### 其他

CGContext类，相当于Android里面的Canvas，使用UIGraphicsGetCurrentContext()获取当前CGContext的引用CGContextRef。我们在每一次的绘制之前都应该保存下原来的状态，待绘制完成后再恢复回原来的状态。所以CGContextSaveGState(ctx);… CGContextRestoreGState(ctx);都应该成对的出现，在他们之间的是绘制UI的代码。

CGPath类用于描述绘制的区域或者路线。在CGContext中addLine，addRect，其实都是在添加path,在添加完成path以后我们可以选择是fill path，还是stroke path。设置相应的 color 和 lineWidth 即可。如果我们只需要在某个区域中绘制，我们可以在描述完path以后使用CGContextClip(ctx)来裁剪当前画布。

CGAffineTransform是一个仿射变换的结构体，相当于一个矩阵，用于进行二维平面的几何变换（平移，旋转，缩放），而且这些几何变换都已经有封装好的函数可调用，变换的顺序就是矩阵连乘的顺序，切不可把矩阵连乘的顺序放反，否则得到的结果可能不一样。

CGColorSpace类是用于界面颜色显示，通常颜色组成为RGBA（红，绿，蓝，透明度）四种，使用CGColorSpaceCreateDeviceRGB获取CGColorSpace的引用CGColorSpaceRef,需要注意的是，在CoreGraphics中，使用create方法生成的引用，最后都需要调用release方法释放掉，如CGColorSpaceCreateDeviceRGB()对应的就是CGColorSpaceRelease(rgb)。

CGLayer 是一个专门用于离屏渲染的context，渲染结果可以重复利用。绘制过程中，可重复利用的渲染效果可以在在 CGLayer 实例中绘制，之后重复利用。