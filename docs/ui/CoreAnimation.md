## Core Animation

```
Core Animation provides high frame rates and smooth animations without burdening the CPU and slowing down your app. Most of the work required to draw each frame of an animation is done for you. You configure animation parameters such as the start and end points, and Core Animation does the rest, handing off most of the work to dedicated graphics hardware, to accelerate rendering.
```

Core Animation 自身并不是一个绘图系统。它只是一个负责在硬件上合成和操纵应用内容的 Framework 。 Core Animation 的核心是图层对象，图层对象用于管理和操控你的应用内容。图层将捕获的内容放到一个位图中，图形硬件能够非常容易的操控你的位图。在大部分应用中，图层被作为一种管理视图内容的方式，但是你也可以创建标准的图层，这取决于你自身的需要。

你使用Core Animation创建的大部分动画都包含对图层属性的更改。像视图一样，图层对象也具有边框矩形、坐标原点、尺寸、不透明度、变换矩阵以及许多其他面向可视的属性（如backgroundColor）。大部分这些属性的值发生了变化都将会触发隐式动画被创建。隐式动画是一种从旧属性值动画到新属性值的动画形式。


### 相关类

- CATransaction 事务类,可以对多个layer的属性同时进行修改.它分隐式事务,和显式事务.
- CAAnimationGroup 允许多个动画同时播放
- CABasicAnimation 提供了对单一动画的实现
- CAKeyframeAnimation 关键桢动画,可以定义行动路线
- CAConstraint 约束类,在布局管理器类中用它来设置属性
- CAConstraintLayoutManager 约束布局管理器,是用来将多个CALayer进行布局的.各个CALayer是通过名称来区分,而布局属性是通过CAConstraint来设置的.


### CATransaction

/* Transactions are CoreAnimation's mechanism for batching multiple layer-
 * tree operations into atomic updates to the render tree. Every
 * modification to the layer tree requires a transaction to be part of.
 *
 * CoreAnimation supports two kinds of transactions, "explicit" transactions
 * and "implicit" transactions.
 *
 * Explicit transactions are where the programmer calls `[CATransaction
 * begin]' before modifying the layer tree, and `[CATransaction commit]'
 * afterwards.
 *
 * Implicit transactions are created automatically by CoreAnimation when the
 * layer tree is modified by a thread without an active transaction.
 * They are committed automatically when the thread's run-loop next
 * iterates. In some circumstances (i.e. no run-loop, or the run-loop
 * is blocked) it may be necessary to use explicit transactions to get
 * timely render tree updates. */

CATransaction 是 Core Animation 中的事务类，在 iOS 中的图层中，图层的每个改变都是事务的一部分。

CATransaction可以对多个layer的属性同时进行修改，同时负责成批的把多个图层树的修改作为一个原子更新到渲染树。

CATransaction事务类分为隐式事务和显式事务，注意以下两组概念的区分：

1. 隐式动画和隐式事务: 隐式动画通过隐式事务实现动画

2. 显式动画和显式事务: 显式动画有多种实现方式，显式事务是一种实现显式动画的方式。


UIView可以设置动画的属性：

    - frame & bounds & center
    - transform、scale、rotate
    - alpha
    - backgroundColor


``` c
//基本
UIView.animateWithDuration(0.5, animations: {
  self.yourView.bounds.size.witdh += 70.0
  self.yourView.backgroundColor = UIColor.greenColor()
  self.yourView.alpha = 0.5
})
//View和View之间的过渡
UIView.transitionWithView(containerView, duration: 0.2, options: .TransitionFlipFromLeft, animations: { _ in fromView.removeFromSuperview(); containerView.addSubview(toView) }, completion: nil)

//入门Option,delay,option自由选择
UIView.animateWithDuration(0.5, delay: 0.4, options: .Repeat, animations:{
    self.yourView.center.x + = 30.0
},completion: nil)

//进阶，Spring属性可以调整动画的弹簧效果
UIView.animateWithDuration(1.5, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.0, options: nil, animations: {
self.loginButton.bounds.size.width += 80.0 
label的文字可以进行一些过渡效果
}, completion: nil)

//高阶，复杂动画组合之KeyFrame
UIView.animateKeyframesWithDuration(1.5, delay: 0.0, options: nil, animations: {
//添加KeyFrames，options中可以选择不同的限制
//1
UIView.addKeyframeWithRelativeStartTime(0.0, relativeDuration: 0.25, animations: {
self.planeImage.center.x += 80.0
self.planeImage.center.y -= 10.0 
})
//2
UIView.addKeyframeWithRelativeStartTime(0.1, relativeDuration: 0.4) { self.planeImage.transform = CGAffineTransformMakeRotation(CGFloat(-
M_PI_4/2)) }
}, completion: nil)

```

### CALayer

layer 内部维护着三分 layer tree


- model Layer Tree(模型树)
- presentation Layer Tree
- Render Layer Tree (渲染树)

#### 动画效果

- size & position改变layer的位置及自身大小
- transform改2D,3D情况下的现实效果
- shadow改变阴影
- border边框效果
- opacity改其透明度

```
//记得引入QuartzCore
//基本
let ownStyle = CABasicAnimation(keyPath:"position.x")
ownStyle.fromValue = -view.bounds.size.width/2
ownStyle.toValue = view,bounds.size.width/2
ownStyle.duration = 0.5
yourView.layer.addAnimation(ownStyle, forKey: nil)
//入门，动画之间存在时间差，我们可以设置fillMode和beginTime来实现特定效果
ownStyle.beginTime = CACurrentMediaTime() + 0.3
ownStyle.fillMode = KCAFillModeRemoved //default
//kCAFillMode主要作用就是控制你动画在开始和结束时候的一些效果
//进阶 CAAnimation delegate pattern
func animationDidStop & animationDidStart
//与block中的相类似，你也可以利用KVC特性设置相应内容
ownStyle.setValue(yourView.layer, forKey:"layer")
ownStyle.setValue("name", forKey:"form")
override func animationStop(anima: CAAnimation!, finished flag: Bool) {
    if let name = ownStyle.valueForKey("form") as? String {
        if name = "form" {
            //add new animation and add it to the layer
        }   
    }
}
//addAnimation中的Key作用，标示动画，在恰当的时候移除对应动画，而不是移除动画效果本身

//高阶，AnimationGroup
let groupAnimation = CAAnimationGroup()
let oneAnimation = CABasicAnimation(keyPath:"transform.scale")
//blablabla
let twoAnimation = CABasicAnimation(keyPath:"opacity")
//detail set for twoAnimation
//sey timingFunction
groupAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
//这么只能一起做动画，这里内部没有时间顺序
groupAnimation.animations = [oneAnimation, twoAnimation] 
yourView.layer.addAnimation(groupAnimation, forKey: nil)
//CAKeyFrame,关键帧动画Layer级别效果
let wobble = CAKeyframeAnimation(keyPath: "transform.rotation") wobble.duration = 0.25
wobble.repeatCount = 4
//比View的keyFrame设置方便多了
//values与keyTimes一一对应
wobble.values = [0.0, -M_PI_4/4, 0.0, M_PI_4/4, 0.0]
wobble.keyTimes = [0.0, 0.25, 0.5, 0.75, 1.0] heading.layer.addAnimation(wobble, forKey: nil)
//不过坑爹的是这样，比如CGPoint，CGSize，CGRect，CATransform3D，都要解包
let move = CABasicAnimation(keyPath: "position")
move.duration = 1.0
move.fromValue = NSValue(CGPoint:CGPoint(x:100.0, y:100.0))
move.toValue = NSValue(CGPoint:CGPoint(x:200.0, y:200.0))
```


position
bounds


### 参考
- http://studentdeng.github.io/blog/2014/06/24/core-animation/
- https://www.calayer.com/core-animation/2016/05/17/catransaction-in-depth.html#flushing-transactions
- https://lision.me/ios_rendering_process/
- https://blog.ibireme.com/2015/05/18/runloop/