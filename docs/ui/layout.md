### 布局更新

#### layoutSubviews

此方法用来重新定义子元素的位置和大小。当子类重写此方法，用来实现UI元素的更精确布局。

很多时候系统会自动调用layoutSubviews方法：
1. view init初始化时不会调动，在 addSubview 时会触发layoutSubviews
2. view 的 frame 有变化时会触发
   1. 直接修改frame 或 center 
   2. 使用 Autolayout (实际也是调整了view的frame)
3. UIScrollView 滚动时会触发
4. 屏幕旋转会触发

#### setNeedsLayout 

标记需要更新layout。保证在下次调用layoutIfNeede时会调用 layoutSubviews。

```
Call this method on your application’s main thread when you want to adjust the layout of a view’s subviews. This method makes a note of the request and returns immediately. Because this method does not force an immediate update, but instead waits for the next update cycle, you can use it to invalidate the layout of multiple views before any of those views are updated. This behavior allows you to consolidate all of your layout updates to one update cycle, which is usually better for performance.

setNeedsLayout makes sure a future call to layoutIfNeeded calls layoutSubviews.
```

#### layoutIfNeeded

强制立刻刷新layout，需要首先调用 setNeedsLayout。


#### setNeedsDisplay 
调用 setNeedsDisplay 后，系统会在在下次渲染过程中调用 drawRect: 重新绘制。

```
You can use this method or the setNeedsDisplayInRect: to notify the system that your view’s contents need to be redrawn.
```
示例：http://blog.fujianjin6471.com/2015/06/11/An-example-of-when-should-setNeedsDisplay-be-called.html


![img](https://i.stack.imgur.com/i9YuN.png)



### 参考：
- https://stackoverflow.com/questions/20609206/setneedslayout-vs-setneedsupdateconstraints-and-layoutifneeded-vs-updateconstra