### 显示器原理

CRT显示器 学名：阴极射线显像管。

是一种使用阴极射线管的显示器。

LCD Liquid Crystal Display 中文：液晶显示器。

Retina 显示屏 就是普通的液晶屏。

显示器显示原理：

![img](http://pc5ouzvhg.bkt.clouddn.com/158CBCE1-05EE-4687-A658-F16AF76B5CC9.jpg)

CRT的电子枪按照上面的方式，上到下一行行扫描，扫描完成后显示器就呈现一帧画面，随后电子枪回到初始位置继续下一次扫描。

当电子枪换到新的一行，准备进行扫描时，显示器会发出一个水平同步信号（horizonal synchronization），简称 HSync；

而当一帧画面绘制完成后，电子枪回复到原位，准备画下一帧前，显示
器会发出一个垂直同步信号（vertical synchronization），简称 VSync。

显示器通常以固定频率进行刷新，这个刷新率就是 VSync 信号产生的频率。

显示器的VSync频率是固定不变的。

详细介绍：

在操作系统与硬件驱动程序的帮助下，用户通过输入设备或者程序向计算机CPU发送一系列的数据，这些数字信号再经过显卡变为不断变化的电压模拟信号，电压控制了液晶的滤光性，像素背后的白光被分成了强弱不同的三原色光，再经人眼的混色作用使得一个像素具有了千变万化的颜色。

### 参考

- https://zhuanlan.zhihu.com/p/32136704