### https


#### 基本流程

详细流程：https://www.jianshu.com/p/b0b6b88fe9fe

![](http://pc5ouzvhg.bkt.clouddn.com/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202018-11-09%20%E4%B8%8B%E5%8D%885.02.18.png)

1 客户端（通常是浏览器）先向服务器发出加密通信的请求 client Hello

```
（1） 支持的协议版本，比如TLS 1.0版。
（2） 一个客户端生成的随机数 random1，稍后用于生成"对话密钥"。
（3） 支持的加密方法，比如RSA公钥加密。
（4） 支持的压缩方法。
```

2 服务器收到请求,然后响应 server Hello

```
（1） 确认使用的加密通信协议版本，比如TLS 1.0版本。如果浏览器与服务器支持的版本不一致，服务器关闭加密通信。
（2） 一个服务器生成的随机数random2，稍后用于生成"对话密钥"。
（3） 确认使用的加密方法，比如RSA公钥加密。
（4） 服务器证书。
```

3 客户端收到证书之后会首先会进行验证

```
如果验证通过，就会显示上面的安全字样，如果服务器购买的证书是更高级的EV类型，就会显示出购买证书的时候提供的企业名称。如果没有验证通过，就会显示不安全的提示。

验证通过之后，客户端会生成一个随机数pre-master secret，然后使用证书中的公钥进行加密，然后传递给服务器端

PreMaster Secret是在客户端使用RSA或者Diffie-Hellman等加密算法生成的。它将用来跟服务端和客户端在Hello阶段产生的随机数random1、random2 结合在一起生成 Master Secret。

```

4 服务器收到使用公钥加密的内容，在服务器端使用私钥解密之后获得随机数pre-master secret，然后根据radom1、radom2、pre-master secret通过一定的算法得出session Key和MAC算法秘钥，作为后面交互过程中使用对称秘钥。同时客户端也会使用radom1、radom2、pre-master secret，和同样的算法生成session Key和MAC算法的秘钥。

5 在后续的交互中就使用session Key和MAC算法的秘钥对传输的内容进行加密和解密。

```
发送方：使用MAC key对内容进行摘要，然后把摘要放在内容的后面使用sessionKey再进行加密。

接收方：先使用 sessionKey 进行解密，然后使用 MAC key对数据完整性进行验证。
```