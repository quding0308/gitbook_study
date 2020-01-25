# HTTP

问题：
- iOS 可以主动设置 http 版本吗？
- url 编码 最终结论
- resp code 总结

## Request
格式：
```
[Request Line] <method> <request-url> <version>
general-header
request-header
entity-header
[空一行]
message-body
```

示例：
```
POST http://www.example.com HTTP/1.1
Content-Type: application/x-www-form-urlencoded;charset=utf-8
accept-language: zh-CN

title=test&sub%5B%5D=1&sub%5B%5D=2&sub%5B%5D=3
```

## Response

格式：
```
[Status Line] <version> <status code> <Reason Phrase>
general-header
response-header
entity-header
[空一行]
message-body
```

示例：
```
HTTP/1.1 200 OK
Content-Length: 3059
Server: GWS/2.0
Date: Sat, 11 Jan 2003 02:44:04 GMT
Content-Type: text/html
Cache-control: private
Set-Cookie: PREF=ID=73d4aef52e57bae9:TM=1042253044:LM=1042253044:S=SMCc_HRPCQiqy
X9j; expires=Sun, 17-Jan-2038 19:14:07 GMT; path=/; domain=.google.com
Connection: keep-alive

<html>...</html>
```

## header

### General Header

### Upgrade

提供一个机制，可以切换 protocol。

```
client 通过 Upgrade 列出希望使用的 ptorocol

server 返回新选定的 protocol， 返回码为 101

```

### Content-Type

#### request post 的Content-Type的设置

```
Content-Type: application/json
Content-Type: application/x-www-form-urlencoded
Content-Type: multipart/form-data
```

#### application/json

post参数以json格式提交

``` shell
:method: POST
:scheme: https
:path: /xuntong/ecLite/convers/v4/groupList
:authority: www.yunzhijia.com
cookie: gl=7b0f2170-0553-4ac4-8b19-f6c271bbc86c
accept: */*
content-type: application/json
accept-language: zh-CN
content-length: 57
x-request-id: 0F02D601-E112-4C0F-8C74-054BC8F8F328
opentoken: 4b3b45a4fe38f22e4cd62e665015bb96
user-agent: 10200/10.1.1;iOS 12.1;Apple;iPhone10,2;102;deviceId:72c9209e-3c13-4987-814f-e0843bfd0f5b;deviceName:quding;clientId:10200;os:iOS 12.1;brand:Apple;model:iPhone10,2;lang:zh-CN;fontNum:0
accept-encoding: br, gzip, deflate

{"useMS":true,"lastUpdateTime":"2018-11-03 14:44:20.135"}
```

#### application/x-www-form-urlencoded

处理 form 表单提交的一种格式，key 和 value 被编码，使用 = 连接，使用 & 分割

``` shell
POST /test HTTP/1.1
Host: foo.example
Content-Type: application/x-www-form-urlencoded
Content-Length: 27

field1=value1&field2=value2
```

#### Content-Type: multipart/form-data

处理 form 表单提交的一种内容格式。每个 value 都被作为单独的一块提交，由定义好的 boundary 作为分隔符

如果有二进制文件要提交，需要使用这种方式

application/x-www-form-urlencoded 与 multipart/form-data 的比较， [参考这里](https://stackoverflow.com/questions/4007969/application-x-www-form-urlencoded-or-multipart-form-data)

``` shell
POST /test HTTP/1.1 
Host: foo.example
Content-Type: multipart/form-data;boundary="boundary" 

--boundary 
Content-Disposition: form-data; name="field1" 

value1 
--boundary 
Content-Disposition: form-data; name="field2"; filename="example.txt" 

value2
--boundary--
```


### HSTS
```
Strict-Transport-Security: max-age=0

HTTP Strict Transport Security（通常简称为HSTS）是一个安全功能，它告诉浏览器只能通过HTTPS访问当前资源，而不是HTTP。

max-age=<expire-time>
设置在浏览器收到这个请求后的<expire-time>秒的时间内凡是访问这个域名下的请求都使用HTTPS请求。
```


### Request Header

```
Host: www.w3.org
必须的参数。

User-Agent: CERN-LineMode/2.15 libwww/2.17b3

Location: http://www.w3.org/pub/WWW/People.html
重定向 

If-Modified-Since: Sat, 29 Oct 1994 19:43:31 GMT
假如请求的资源在该日期之后没有modify，则返回 304 ，不会反回 entity

```

### Response Header

#### Cache-Control

```
Cache-Control: public, max-age=0
```

#### ETag

https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/ETag

资源的一个版本都会生成唯一的 ETag，使用 ETag 可以节省贷带宽，加载速度更快，让 cache 更有效率

示例：
``` shell
ETag: "33a64df551425fcc55e4d42a148795d9f25f89d4"
```

ETag + If-Match 可以在修改资源时检测到中间版本的冲突。

例如，编辑 wiki 页面时，点击提交时，在 post request 中加上 If-Match ，把修改前的 ETag 传给 server 。如果 Server 校验不通过，会返回 412 Precondition Failed

ETag + If-None-Match 可以在修改资源时检测到中间版本的冲突。

在 request header 添加 If-None-Match 传递本地的 ETag ，Server 比较 client's ETag 和 server's ETag ，如果没有变化，则返回 304 Not Modified

### Entity

### Entity Header

```
Allow: GET, HEAD, PUT
一般，返回 405(Method Not Allowed) 时，会返回 Allow Header，列出该 Request-URI 支持的 methods


Content-Encoding         

Content-Language         

Content-Length           

Content-Location         

Content-MD5              

Content-Range            

Content-Type             

Expires                  

Last-Modified            

extension-header

```

## Entity Body



## response 的返回数据
```
:status: 200
server: openresty
date: Sat, 03 Nov 2018 06:47:07 GMT
content-type: application/json;charset=UTF-8
vary: Accept-Encoding
strict-transport-security: max-age=15768000
strict-transport-security: max-age=0
content-encoding: gzip

{"data":null,"errorMessage":"验证用户失败","success":false,"errorCode":10008}
```


## HTTP2.0和HTTP1.X相比的新特性

- tcp连接 复用
- header 压缩


## Status Code 状态码

- 1xx 消息请求已被服务器接收，等待继续处理
- 2xx 请求已成功被服务器接收、理解、并接受
- 3xx 重定向
- 4xx 客户端请求错误
- 5xx 服务端错误

常用错误码：
```
100 Continue
101 Switching Protocols
服务器已经理解了客户端的请求，并将通过 Upgrade 消息头通知客户端采用不同的协议来完成这个请求。在发送完这个响应最后的空行后，服务器将会切换到在Upgrade消息头中定义的那些协议。WebSocket 在创建连接阶段，切换协议

200 OK
201 Created
202 Accepted
204 No Content 服务器正常处理了请求，但没有资源返回
206 Partial Content 表示客户端进行了范围请求，服务端成功执行了这次请求

301 Moved Permanently 资源被永久移动到了新位置，之后使用新的url访问资源（如果保存为了书签，书签也会更新）
302 Found 临时重定向 请求的资源被分配了新的 url ，本次访问使用新 url
303 See Other 与 302 类似，但需要明确使用 GET 访问
304 Not Modified 资源未修改，不会返回响应body

400 Bad Request 表示请求报文中存在语法错误
401 Unauthorized 发送的请求需要通过 http 认证
403 Forbidden 服务器已接收到请求，但拒绝了访问
404 Not found 服务器上无法找到请求资源
405 Method Not Allowed
412 Precondition Failed

500 Internal Server Error 服务器在处理请求时发生错误（可能是代码bug）
501 Not Implemented
502 Bad Gateway
503 Service Unavailable 服务器无法处理请求，服务器可能处于超负载或正在停机维护
```

## 参考

- http: https://tools.ietf.org/html/rfc2616#section-5
- https://zh.wikipedia.org/wiki/HTTP%E7%8A%B6%E6%80%81%E7%A0%81#1xx%E6%B6%88%E6%81%AF