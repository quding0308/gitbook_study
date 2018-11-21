## Content Security Policy

CSP 的实质就是白名单制度，开发者明确告诉客户端，哪些外部资源可以加载和执行，等同于提供白名单。它的实现和执行全部由浏览器完成，开发者只需提供配置。使用 CSP 主要防止 XSS 攻击。

### 启用CSP
#### 设置 Content-Security

```
Content-Security-Policy: script-src 'self'; object-src 'none';
style-src cdn.example.org third-party.org; child-src https:
```

#### 设置 <meta> 标签

```
<meta http-equiv="Content-Security-Policy" content="script-src 'self'; object-src 'none'; style-src cdn.example.org third-party.org; child-src https:">
```

#### 具体配置

```
script-src 'self';  // js只信任当前域名
object-src 'none';  // <object>标签 不信任任何URL，即不加载任何资源
style-src cdn.example.org third-party.org;  // css 只信任 cdn.example.org和third-party.org
child-src https:    // 其他资源：没有限制
```

示例：

```
// 各配置的默认选项 self  所有外部资源只能从当前域名加载
Content-Security-Policy: default-src 'self'
```

### 参考

- http://www.ruanyifeng.com/blog/2016/09/csp.html
- https://developer.mozilla.org/zh-CN/docs/Web/HTTP/CSP


## 同源策略 

same-origin policy

同源政策的目的，是为了保证用户信息的安全，防止恶意的网站窃取数据。

如果网站没有提供CSP头部，则浏览器使用标准的同源策略。

### 什么是同源
同源 指 域名、协议、端口都相同。

scheme + host + port 都相同才算是**同源**。

同一域名下的 http 和 https请求 属于不同源

### 同源策略的限制：

1. Cookie、LocalStorage、IndexDB无法读取
2. DOM 无法获取
3. Ajax 请求不能发送

### 参考

- http://www.ruanyifeng.com/blog/2016/04/same-origin-policy.html
- https://developer.mozilla.org/zh-CN/docs/Web/Security/Same-origin_policy

## CORS

Cross-Origin Resource Sharing 跨域资源共享

跨域资源共享(CORS) 是一种机制，它使用额外的 HTTP 头来告诉浏览器  让运行在一个 origin (domain) 上的Web应用被准许访问来自不同源服务器上的指定的资源。当一个资源从与该资源本身所在的服务器不同的域或端口请求一个资源时，资源会发起一个跨域 HTTP 请求。

### 简单请求

浏览器发现ajax请求时跨源的请求，会自动在request header增加Origin字段

```
GET /cors HTTP/1.1
Origin: http://api.bob.com
Host: api.alice.com
Accept-Language: en-US
Connection: keep-alive
User-Agent: Mozilla/5.0
```

服务器根据Origin决定是否同意这次请求。如果Origin指定的域名在许可范围内，则服务器返回response，会在header 多增加几个字段

```
Access-Control-Allow-Origin: http://api.bob.com     // 表示 server 接受的域名请求
Access-Control-Allow-Credentials: true  // 告知浏览器是否可以携带cookie
Access-Control-Expose-Headers: FooBar   // 
Content-Type: text/html; charset=utf-8
```

### 参考

- https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Access_control_CORS
- http://www.ruanyifeng.com/blog/2016/04/cors.html