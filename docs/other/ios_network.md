## iOS 网络相关

### URLSession

![img](/asserts/img/network1.png)

``` shell
URLSession

URLSessionConfiguration

URLSessionTask
    URLSessionDataTask
    URLSessionDownloadTask
    URLSessionUploadTask
    URLSessionStreamTask

URLSessionTask 中包含：
    URLRequest
    URLResponse

HTTPURLResponse
```


### AFNetworking

AFNetworkReachabilityManager 什么原理？是否可以监听弱网络？


**AFNetworking 库中一共有 6 个文件**

- 2 个 SessionManager
    - AFURLSessionManager
    - AFHTTPSessionManager
- 2 个 Serialization
    - AFURLRequestSerialization 
    - AFURLResponseSerialization
- AFNetworkReachabilityManager
- AFSecurityPolicy

类关系：



#### AFNetworkReachabilityManager 

每次调用 [AFNetworkReachabilityManager manager] 都会创建一个新的实例。

#### AFSecurityPolicy

安全策略

``` shell
allowInvalidCertificates // 是否允许无效的证书

validatesDomainName // 是否需要验证域名



```

defaultPolicy 

``` shell
not allow invalid certificates, validates domain name, and does not validate against pinned certificates or public keys
```