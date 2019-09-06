### https 解决的问题

#### 1可能窃听

http 的报文是明文，会被直接看到。https 会做加密，防止被看到。

#### 2服务器的认证问题

无法确认发送到的服务器就是真正的服务器。https 通过校验 服务器的证书来确认服务器的身份。

#### 3防止被篡改

请求或响应在传输图中可能被篡改。https通过数据加密、解密，防止数据的篡改。通过 数据MAC校验 数据的完整性。

### 基本流程

参考：

1. tls文章
2. https://juejin.im/entry/5a644a61f265da3e4c07e334

### https 证书

https 证书内包括：

- 签发机构
- 申请者
- 域名 domain
- 公钥 pub_server
- 证书有效期
- 摘要

### 参考

- https:https://tools.ietf.org/html/rfc2818.html
- https://segmentfault.com/a/1190000015155372
- 详细流程：https://www.jianshu.com/p/b0b6b88fe9fe


校验域名
校验证书
