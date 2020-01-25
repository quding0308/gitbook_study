## 调试

### color blended layer

是否有图层合并&混合的才做。可以看到哪个layer层有做合成操作，即哪个 layer 是透明的。
Views that are drawn on top of other views and that have blending enabled are overlaid in red. Other areas are overlaid in green.

### color misaligned images

像素是否对齐，GPU 是否有做额外的计算用于将多个像素混合起来生成一个用来合成的值。
Images whose bounds are not aligned to the destination pixels are overlaid in magenta.
Images drawn with a scale factor are overlaid in yellow.

### Color Copied Images

Images that Core Animation must copy instead of using the original are overlaid in blue.

### color Offline Screen Render

Content that is rendered offscreen is overlaid in yellow.

#### Color Offscreen-Rendered Yellow

将已经被渲染到屏幕外缓冲区的区域标注为黄色

#### Color Hits Green and Misses Red 

绿色代表无论何时一个屏幕外缓冲区被复用，而红色代表当缓冲区被重新创建

