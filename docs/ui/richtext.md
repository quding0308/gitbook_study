## 富文本

```
涉及到 NSMutableAttributedString 和 CoreText






```

### NSAttributedString

#### NSMutableParagraphStyle

对应文本中段落，可还是在的属性包括：
```
// 行间距
@property (NS_NONATOMIC_IOSONLY) CGFloat lineSpacing;

// 段落间距
@property (NS_NONATOMIC_IOSONLY) CGFloat paragraphSpacing;

// 水平对齐方式
@property (NS_NONATOMIC_IOSONLY) NSTextAlignment alignment;

// 首行缩进
@property (NS_NONATOMIC_IOSONLY) CGFloat firstLineHeadIndent;

// 整体缩进
@property (NS_NONATOMIC_IOSONLY) CGFloat headIndent;
@property (NS_NONATOMIC_IOSONLY) CGFloat tailIndent;

// 换行模式
@property (NS_NONATOMIC_IOSONLY) NSLineBreakMode lineBreakMode;
@property (NS_NONATOMIC_IOSONLY) CGFloat minimumLineHeight;
@property (NS_NONATOMIC_IOSONLY) CGFloat maximumLineHeight;
@property (NS_NONATOMIC_IOSONLY) NSWritingDirection baseWritingDirection;
@property (NS_NONATOMIC_IOSONLY) CGFloat lineHeightMultiple;

// 段落前间距
@property (NS_NONATOMIC_IOSONLY) CGFloat paragraphSpacingBefore;
@property (NS_NONATOMIC_IOSONLY) float hyphenationFactor;
```

### Attibutes 设置

```
@{
    NSForegroundColorAttributeName : UIColor.whiteColor,
    NSFontAttributeName : [UIFont systemFontOfSize:smallSize],
    NSParagraphStyleAttributeName : paragraphStyle2,
    NSKernAttributeName : @(-0.3f)
};

```

**NSAttributedString中可设置的字符属性**

```
 NSString *const NSFontAttributeName;(字体)
 NSString *const NSParagraphStyleAttributeName;(段落)
 NSString *const NSForegroundColorAttributeName;(字体颜色)
 NSString *const NSBackgroundColorAttributeName;(字体背景色)
 NSString *const NSLigatureAttributeName;(连字符)
 NSString *const NSKernAttributeName;(字间距)
 NSString *const NSStrikethroughStyleAttributeName;(删除线)
 NSString *const NSUnderlineStyleAttributeName;(下划线)
 NSString *const NSStrokeColorAttributeName;(边线颜色)
 NSString *const NSStrokeWidthAttributeName;(边线宽度)
 NSString *const NSShadowAttributeName;(阴影)(横竖排版)
 NSString *const NSVerticalGlyphFormAttributeName;

 常量
 1> NSFontAttributeName(字体)
 该属性所对应的值是一个 UIFont 对象。该属性用于改变一段文本的字体。如果不指定该属性，则默认为12-point Helvetica(Neue)。

 2> NSParagraphStyleAttributeName(段落)
 该属性所对应的值是一个 NSParagraphStyle 对象。该属性在一段文本上应用多个属性。如果不指定该属性，则默认为 NSParagraphStyle 的defaultParagraphStyle 方法返回的默认段落属性。

 3> NSForegroundColorAttributeName(字体颜色)
 该属性所对应的值是一个 UIColor 对象。该属性用于指定一段文本的字体颜色。如果不指定该属性，则默认为黑色。

 4> NSBackgroundColorAttributeName(字体背景色)
 该属性所对应的值是一个 UIColor 对象。该属性用于指定一段文本的背景颜色。如果不指定该属性，则默认无背景色。

 5> NSLigatureAttributeName(连字符)
 该属性所对应的值是一个 NSNumber 对象(整数)。连体字符是指某些连在一起的字符，它们采用单个的图元符号。0 表示没有连体字符。1 表示使用默认的连体字符。2表示使用所有连体符号。默认值为 1（注意，iOS 不支持值为 2）。

 6> NSKernAttributeName(字间距)
 该属性所对应的值是一个 NSNumber 对象(整数)。字母紧排指定了用于调整字距的像素点数。字母紧排的效果依赖于字体。值为 0 表示不使用字母紧排。默认值为0。

 7> NSStrikethroughStyleAttributeName(删除线)
 该属性所对应的值是一个 NSNumber 对象(整数)。该值指定是否在文字上加上删除线，该值参考“Underline Style Attributes”。默认值是NSUnderlineStyleNone。

 8> NSUnderlineStyleAttributeName(下划线)
 该属性所对应的值是一个 NSNumber 对象(整数)。该值指定是否在文字上加上下划线，该值参考“Underline Style Attributes”。默认值是NSUnderlineStyleNone。

 9> NSStrokeColorAttributeName(边线颜色)
 该属性所对应的值是一个 UIColor 对象。如果该属性不指定（默认），则等同于 NSForegroundColorAttributeName。否则，指定为删除线或下划线颜色。更多细节见“Drawing attributedstrings that are both filled and stroked”。

 10> NSStrokeWidthAttributeName(边线宽度)
 该属性所对应的值是一个 NSNumber 对象(小数)。该值改变描边宽度（相对于字体size 的百分比）。默认为 0，即不改变。正数只改变描边宽度。负数同时改变文字的描边和填充宽度。例如，对于常见的空心字，这个值通常为3.0。

 11> NSShadowAttributeName(阴影)
 该属性所对应的值是一个 NSShadow 对象。默认为 nil。

 12> NSVerticalGlyphFormAttributeName(横竖排版)
 该属性所对应的值是一个 NSNumber 对象(整数)。0 表示横排文本。1 表示竖排文本。在 iOS 中，总是使用横排文本，0 以外的值都未定义。

```


### TextKit

![](https://upload-images.jianshu.io/upload_images/3691932-e7e64ca250f8e857.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/382/format/webp)

![](https://img-blog.csdn.net/20130817133048625)

#### NSTextContainer

NSTextContainer 定义了**文字排版的区域**，一般是定义一个矩形的区域，但是可以创建一个它的子类来自定义各种类型的区域，除此之外，还可以设置一组Bezier Paths来实现绕排效果。

#### NSTextStorage

NSTextStorage 是 NSMutableAttributedString 的一个子类，它的作用是存储着字符和属性，被文本系统操作着。除了存储字符，它还管理着所有的排版的对象(NSLayoutManager)，当字符或属性发生改变的时候会通知排版的对象重新排版。

#### NSLayoutManager

它把所有文本处理的对象协调起来，转换NSTextStorage中存储的文本渲染出来，映射字符到字形，并排版到NSTextContainer指定的区域里去。

一个 NSLayoutManager 使用 NSTextContainer 去决定 在哪里换行，布局部分文本

NSLayoutManger 对象主要会执行这些操作：
* 控制 text storage 和 text container 对象
* 转换字符到字型
* 计算字符位置和存储的信息
* 管理字符和字型的range
* 绘制字型到文本窗口
* 计算一行排版的边框
* 控制连字符
* 控制字符字形属性

### 参考
- https://juejin.im/post/5a24afd3f265da431e16968f
- YYText: https://github.com/ibireme/YYText
- https://www.jianshu.com/p/e988d2030a08