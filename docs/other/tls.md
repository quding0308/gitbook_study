

## Handsahke Protocol




@startuml

participant c as "禅道"
participant jm as "jenkins master"
participant js as "jenkins slave"
participant ftp as "ftp 服务器"

c -> jm: 点击：构建 
activate jm

jm -> js: 选择 salve ，执行脚本
deactivate jm
activate js

js -> c: 开始构建

js --> js: 从禅道下载资源、证书

js --> js: 替换图片资源，替换 KDMixedCloudConfig 文件

js --> js: 读取 ios.property , 替换参数，保存到 integration.plist 中

js --> js: 导入证书，检测 group 是否一致

js --> js: 替换 info.plist 中的参数

js --> js: 多语言处理，更新 InfoPlist.strings

js --> js: 更新 entitlements ，修改 group

js --> js: 更新 project.pbxproj ，修改 bundle id，provisioning file name

js --> js: 修改 Podfile ，执行 sh pod_install 

js --> js: xcode-select -switch 命令

js --> js: xcodebuild 构建

js --> js: 修改 enterprise.plist ，准备 archive

js --> js: xcodebuild -exportArchive 打包

deactivate js

js --> jm: 把 ipa 和 plist scp 到 master

js --> ftp: ipa、plist、dsym 上传到 ftp 服务器

js -> c: 构建完成

@enduml


#### ClientHello

ClientHello 发送的数据包括：

- client_version  (tls版本)
- random;    // ranome struct
- session_id (可能为空, 用于标识当前的connection)
- cipher_suites （client 支持的加密算法 list）
- compression_methods （client 支持的压缩算法）

```
struct {
    uint32 gmt_unix_time;   // current time
    opaque random_bytes[28];    // 随机产生的 28 bytes
} Random;
```

#### 1ServerHello

Server 当收到了 ClientHello 后，向 client 发送 ServerHello

ServerHello 包含数据：

- server_verison    ()
- random (由 server 生成的 random struct)
- session_id  (用于标识 connection，如果 ClientHello 没有传，则会生成一个新的)
- cipher_suite (由 server 选中的加密算法)
- compression_method (由 server 选中的压缩算法)

#### 2Server Certificate

向 client 发送证书和公钥

#### 3Server Key Exchange Message

The ServerKeyExchange message is sent by the server only when the
      server Certificate message (if sent) does not contain enough data
      to allow the client to exchange a premaster secret.

#### 4Certificate Request

向 client 请求证书

#### 5Server Hello Done

当 ServerHello 和 相关信息发送完后，server 会发送 ServerHelloDone。之后会等待 client 的响应。

#### 6Client Certificate

当 client 接收到  ServerHelloDone 后。如果 server 要求证书，client 会向 server 发送 ClientCertificate 


#### 7Client Key Exchange Message

由 client 发送。 

client 生成一个随机数 pre_master_key，然后通过 server-rsa-public-key 加密，发送给 server。



#### 8Certificate Verify


#### 9Finished


参考：

- https://www.ietf.org/rfc/rfc5246.txt