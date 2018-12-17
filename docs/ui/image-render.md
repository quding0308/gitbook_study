## Image 加载流程

```
- (void)testImageLoad {
    [self.view addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).mas_offset(40);
        make.left.mas_equalTo(self.view);
        
        make.width.height.mas_equalTo(50);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 此时图片并没有解压缩
        // 系统实际上只是在 Bundle 内查找到文件名，然后把这个文件名放到 UIImage 里返回，并没有进行实际的文件读取和解码。
        UIImage *img = [UIImage imageNamed:@"image"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 赋值时，开始从磁盘读取图片文件，解压缩，渲染图层
            self.imgView.image = img;
        });
    });
}
```

将生成的 UIImage 赋值给 UIImageView 后执行的流程：

1. 一个隐式的 CATransaction 捕获到了 UIImageView 图层树的变化
2. 在主线程的下一个 run loop 到来时，Core Animation 提交了这个隐式的 transaction，读取图片文件，渲染：
   1. 分配内存缓冲区用于管理文件 IO 和解压缩操作
   2. 将文件数据从磁盘读到内存中
   3. 将压缩的图片数据解码成未压缩的位图形式，这是一个非常耗时的 CPU 操作
   4. 最后 Core Animation 使用未压缩的位图数据渲染 UIImageView 的图层

### 在子线程中强制解压缩生成image

图片解压缩的过程其实就是将图片的二进制数据转换成像素数据的过程。

位图就是一个像素数组，数组中的每个像素就代表着图片中的一个点。我们在应用中经常用到的 JPEG 和 PNG 图片就是位图。

解压缩后的图片大小 = 图片的像素宽 30 * 图片的像素高 30 * 每个像素所占的字节数 4

原理：使用绘制的接口，把image 在子线程中绘制到context中，然后生成image，即完成解压缩过程。

```
CGImageRef YYCGImageCreateDecodedCopy(CGImageRef imageRef, BOOL decodeForDisplay) {
    ...

    if (decodeForDisplay) { // decode with redraw (may lose some precision)
        CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef) & kCGBitmapAlphaInfoMask;

        BOOL hasAlpha = NO;
        if (alphaInfo == kCGImageAlphaPremultipliedLast ||
            alphaInfo == kCGImageAlphaPremultipliedFirst ||
            alphaInfo == kCGImageAlphaLast ||
            alphaInfo == kCGImageAlphaFirst) {
            hasAlpha = YES;
        }

        // BGRA8888 (premultiplied) or BGRX8888
        // same as UIGraphicsBeginImageContext() and -[UIView drawRect:]
        CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host;
        bitmapInfo |= hasAlpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst;

        // 1. 创建上下文
        CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 0, YYCGColorSpaceGetDeviceRGB(), bitmapInfo);
        if (!context) return NULL;

        // 2. 将原始位图绘制到上下文中
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef); // decode
        
        // 创建一张新的解压缩后的位图
        CGImageRef newImage = CGBitmapContextCreateImage(context);
        
        CFRelease(context);

        return newImage;
    } else {
        ...
    }
}
```

在 SD 中对应的实现 在 
```
#import "SDWebImageDecoder.h"

+ (nullable UIImage *)decodedImageWithImage:(nullable UIImage *)image {
    if (![UIImage shouldDecodeImage:image]) {
        return image;
    }
    
    // autorelease the bitmap context and all vars to help system to free memory when there are memory warning.
    // on iOS7, do not forget to call [[SDImageCache sharedImageCache] clearMemory];
    @autoreleasepool{
        
        CGImageRef imageRef = image.CGImage;
        CGColorSpaceRef colorspaceRef = [UIImage colorSpaceForImageRef:imageRef];
        
        size_t width = CGImageGetWidth(imageRef);
        size_t height = CGImageGetHeight(imageRef);
        size_t bytesPerRow = kBytesPerPixel * width;

        // kCGImageAlphaNone is not supported in CGBitmapContextCreate.
        // Since the original image here has no alpha info, use kCGImageAlphaNoneSkipLast
        // to create bitmap graphics contexts without alpha info.
        CGContextRef context = CGBitmapContextCreate(NULL,
                                                     width,
                                                     height,
                                                     kBitsPerComponent,
                                                     bytesPerRow,
                                                     colorspaceRef,
                                                     kCGBitmapByteOrderDefault|kCGImageAlphaNoneSkipLast);
        if (context == NULL) {
            return image;
        }
        
        // Draw the image into the context and retrieve the new bitmap image without alpha
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
        CGImageRef imageRefWithoutAlpha = CGBitmapContextCreateImage(context);
        UIImage *imageWithoutAlpha = [UIImage imageWithCGImage:imageRefWithoutAlpha
                                                         scale:image.scale
                                                   orientation:image.imageOrientation];
        
        CGContextRelease(context);
        CGImageRelease(imageRefWithoutAlpha);
        
        return imageWithoutAlpha;
    }
}
```


### 图片做压缩，去掉 alpha 通道

在 SD 中，无法在子线程解压带有 alpha 通道的图片


### 参考
- http://blog.leichunfeng.com/blog/2017/02/20/talking-about-the-decompression-of-the-image-in-ios/
- https://www.jianshu.com/p/e9843d5b70a2
