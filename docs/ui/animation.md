## Core Animation

### 相关类

- CATransition 提供渐变效果:(推拉push效果,消退fade效果,揭开reveal效果)
- CAAnimationGroup 允许多个动画同时播放
- CABasicAnimation 提供了对单一动画的实现
- CAKeyframeAnimation 关键桢动画,可以定义行动路线
- CAConstraint 约束类,在布局管理器类中用它来设置属性
- CAConstraintLayoutManager 约束布局管理器,是用来将多个CALayer进行布局的.各个CALayer是通过名称来区分,而布局属性是通过CAConstraint来设置的.
- CATransaction 事务类,可以对多个layer的属性同时进行修改.它分隐式事务,和显式事务.



### CATransaction
CATransaction是 Core Animation 中的事务类，在iOS中的图层中，图层的每个改变都是事务的一部分。

CATransaction可以对多个layer的属性同时进行修改，同时负责成批的把多个图层树的修改作为一个原子更新到渲染树。

CATransaction事务类分为隐式事务和显式事务，注意以下两组概念的区分：
1. 隐式动画和隐式事务:

隐式动画通过隐式事务实现动画 。

2. 显式动画和显式事务:

显式动画有多种实现方式，显式事务是一种实现显式动画的方式。

layer 内部维护着三分 layer tree,
- presentLayer Tree(动画树),
- modeLayer Tree(模型树)
- Render Tree (渲染树)


### 参考
- http://studentdeng.github.io/blog/2014/06/24/core-animation/
