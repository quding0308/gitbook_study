### 内存优化


降低内存峰值
- UIGraphicsBeginImageContext和UIGraphicsEndImageContext必须成双出现，不然会造成context泄漏。
- WebView 替换 
- 适当的添加 autoreleasetool能够及时释放内存，降低峰值
- 相互引用 self 被 block 持有  NSTimer 释放

线上内存监控：
https://juejin.im/post/5aa79eeaf265da2392360487

