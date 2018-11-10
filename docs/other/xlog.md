### xlog


#### xlog整体流程：

生成一条log -> 格式化数据 -> 压缩 -> 加密 -> 写入内存 (-> 可能会写入mmap文件) -> 超过1/3大小后，写入本地文件


#### xlog 高效的日志系统

##### 收集日志 不卡顿，会压缩

##### 自动上传，指定某个用户的日志上传

更多：https://mp.weixin.qq.com/s/PnICVDyVuMSyvpvTrdEpSQ?

