

* 目录
{:toc}

### mars

优点：

- 跨平台，只需维护一套代码
- 提供长连、短连 两种网络通道
- 动态下发ip，就近接入
- 贴合移动端的平台特性：前后台切换、网络切换 会检测连接是否连通
- 智能心跳
- 高效的日志组件 xlog


ask
```
1. mars 相比 tcp 的优化点
2. mars 相比 websocket 的优化点


弱网优化
连接优化
发消息优化
智能心跳优化
超时重传优化
多IP优化

```

#### 弱网优化

弱网情况下 上下行 3k/2k mars 明显优于 websocket，websocket 基本收不到消息
弱网情况下 上下行 8k 断网重连后，明显优于websocket 快 3s 左右 

#### 连接优化
iOS 的 connect 超时重传如下图所示。超时间隔依次为（1，1，1，1，1，2，4，8，16，32），总共是67s。

这就意味着，在不能立刻确认失败（例如 unreachable 等）的情况下，需要67秒的时间，才能获得结果。如果真相并不是用户的网络不可用，而是某台服务器故障、繁忙、网络不稳定等因素，那75秒的时间只能尝试1个 IP&Port 资源，对于大多数移动应用而言，是不可接受的。我们需要更积极的超时重传机制！！！

我们不能修改TCP的超时机制。在应用层超时重传，典型做法就是提前结束 connect 的阻塞调用，使用新的 IP&Port 资源进行 connect 重试。

更多详细：https://mp.weixin.qq.com/s?__biz=MzAwNDY1ODY2OQ==&mid=2649286458&idx=1&sn=320f690faa4f97f7a49a291d4de174a9&chksm=8334c3b8b4434aae904b6d590027b100283ef175938610805dd33ca53f004bd3c56040b11fa6#rd

#### 发消息优化

长短连 两种模式自动切换

发的数据多的时候，长连可能会慢，会切换到 短连发送
弱网情况下，长连可能已经断了，此时 通过短连发送效果会更好

#### 智能心跳优化

根据 前后台状态 和 心跳失败的次数 自动判断 **心跳的时间**

#### 多IP

自动切换IP，提升连接速度

#### 超时重传

在TCP的超时重传的基础上，在应用层有自己的超时重传逻辑，尽可能提高成功率。

TCP 层的超时重传机制可以发现，当发生超时重传时，重传的间隔以“指数退避”的规律急剧上升。在 Android 系统中，直到16分钟，TCP 才确认失败；在 iOS 系统中，直到1分半到3分半之间，TCP 才确认失败。这些数值在大部分应用中都是不为“用户体验”所接受的。用户体验太差。

设计思路：
- 减少等待时间，增加重试次数
- 切换链路(ip/port)，重新建立连接

优化1：

根据网络的状况：优质、正常、差，分别设置超时时间。优质的网络，超时时间设置短（预期网络恢复快）

#### 超时

在 Mars 中有四个超时概念，分别为首包超时、包包超时、读写超时、任务超时。首包超时为从请求发出去到收到第一个包最大等待时长，读写超时则是单次请求从发送请求到收到完整回包的最大等待时长，计算公式分别为：

- 首包超时 = 发包大小/最低网速+服务器约定最大耗时+并发数*常量；
- 包包超时 = 常量；
- 读写超时 = 首包超时+最大回包大小/最低网速；
- 任务超时 = (读写超时 + 常量) * 重试次数。


在mars的读写超时计算中，有一个最大回包大小，预估值为64k。
**mars 不建议传输大数据，一般用来传输信令**

### 项目中使用

#### 一、增加了加密、压缩功能

修改以下文件，增加RSA、AES和ZLIB相关函数

```
\merc\client\mars\mars\openssl\export_include\aes_crypt.h
\merc\client\mars\mars\openssl\export\aes_crypt.c
\merc\client\mars\mars\openssl\export_include\rsa_crypt.h
\merc\client\mars\mars\openssl\export\crypto\rsa_crypt.cpp
```

#### 二、增加了用户login，session 管理逻辑

更新以下文件

```
\merc\client\mars\mars\stn\stn_logic.h: 增加SetParameter,OpenSession,CloseSession,GetSessionId,GetCurrentLonglinkIp,ClearCmds所有接口定义；
\merc\client\mars\mars\stn\stn_logic.cc: 增加OnOpenSession回调实现
\merc\client\mars\mars\stn\proto\longlink_packer.cc: 长连封包格式及核心业务扩展实现
\merc\client\mars\mars\libraries\mars_android_sdk\jni\longlink_packer.cc: 安卓编译需要
\merc\client\mars\mars\stn\src\net_core.h: 主要配合实现 ClearCmds, GetCurrentLonglinkIp 接口
\merc\client\mars\mars\stn\src\net_core.cc: 同上
\merc\client\mars\mars\stn\src\longlink_task_manager.h: 同上
\merc\client\mars\mars\stn\src\longlink_task_manager.cc: 同上
\merc\client\mars\mars\stn\src\longlink.cc: 优化session_id为0不发送心跳数据
```

### 三、优化 切换账户，可以服用之前的tcp连接

重新做login操作即可

### 客户端编译脚本:

```
\merc\client\mars\mars\libraries\build_android.py
\merc\client\mars\mars\libraries\build_apple.py
\merc\client\mars\mars\libraries\build_for_win32.py
```