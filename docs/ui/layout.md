### layoutSubviews

#### layoutSubviews

此方法用来重新定义子元素的位置和大小。当子类重写此方法，用来实现UI元素的更精确布局。

注意：当 layoutSubviews 调用时，也会自动触发调用 updateConstraintsIfNeeded

很多时候系统会自动调用layoutSubviews方法：
1. 初始化不会触发layoutSubviews，但是如果设置了不为CGRectZero的frame的时候就会触发。
2. addSubview会触发layoutSubviews
3. 设置view的Frame会触发layoutSubviews，当然前提是frame的值设置前后发生了变化
4. 滚动一个UIScrollView会触发layoutSubviews
5. 旋转Screen会触发父UIView上的layoutSubviews事件
6. 改变一个UIView大小的时候也会触发父UIView上的layoutSubviews事件

#### setNeedsLayout 

刷新布局，不会立即刷新

```
Call this method on your application’s main thread when you want to adjust the layout of a view’s subviews. This method makes a note of the request and returns immediately. Because this method does not force an immediate update, but instead waits for the next update cycle, you can use it to invalidate the layout of multiple views before any of those views are updated. This behavior allows you to consolidate all of your layout updates to one update cycle, which is usually better for performance.

setNeedsLayout makes sure a future call to layoutIfNeeded calls layoutSubviews.
```

#### layoutIfNeeded

立即刷新布局

#### setNeedsDisplay 
调用 setNeedsDisplay 后，系统会调用 drawRect: 重新绘制。

```
You can use this method or the setNeedsDisplayInRect: to notify the system that your view’s contents need to be redrawn.
```
示例：http://blog.fujianjin6471.com/2015/06/11/An-example-of-when-should-setNeedsDisplay-be-called.html


### updateConstraints

#### updateConstraints

由system调用，更新约束。

```
It is almost always cleaner and easier to update a constraint immediately after the affecting change has occurred. For example, if you want to change a constraint in response to a button tap, make that change directly in the button’s action method.

You should only override this method when changing constraints in place is too slow, or when a view is producing a number of redundant changes.

当更新的约束比较多 或 约束修改耗时，可以放到这里。一般情况 直接放到对应的代码业务代码中即可。
```

#### setNeedsUpdateConstraints

类似于 setNeedsLayout 的的逻辑

```
setNeedsUpdateConstraints makes sure a future call to updateConstraintsIfNeeded calls updateConstraints.
```

### updateConstraintsIfNeeded

类似于 layoutIfNeeded 的的逻辑，system 会立即调用 updateConstraints

![图片](https://i.stack.imgur.com/i9YuN.png)



### 参考：
- https://stackoverflow.com/questions/20609206/setneedslayout-vs-setneedsupdateconstraints-and-layoutifneeded-vs-updateconstra