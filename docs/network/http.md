## http

### Request
格式
```
[Request Line] <method> <request-URL> <version> [CRLF]
general-header
request-header
entity-header[CRLF]
[CRLF]
message-body
```

```
POST http://www.example.com HTTP/1.1
Content-Type: application/x-www-form-urlencoded;charset=utf-8
accept-language: zh-CN

title=test&sub%5B%5D=1&sub%5B%5D=2&sub%5B%5D=3
```


### Response

格式：

```
[Status Line] <version> <status code> <Reason Phrase> [CRLF]
general-header
response-header
entity-header[CRLF]
[CRLF]
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

### Status Code 状态码

- 1xx 消息——请求已被服务器接收，继续处理 Request received, continuing process
- 2xx 成功——请求已成功被服务器接收、理解、并接受
- 3xx 重定向——需要后续操作才能完成这一请求 Further action must be taken in order to
        complete the request
- 4xx 请求错误——请求含有词法错误或者无法被执行 Client Error - The request contains bad syntax or cannot be fulfilled
- 5xx 服务器错误——服务器在处理某个正确请求时发生错误 The server failed to fulfill an apparently
        valid request

```
100 Continue
101 Switching Protocols
服务器已经理解了客户端的请求，并将通过Upgrade消息头通知客户端采用不同的协议来完成这个请求。在发送完这个响应最后的空行后，服务器将会切换到在Upgrade消息头中定义的那些协议。WebSocket 使用

200 OK
201 Created
202 Accepted

301 Moved Permanently **重定向**资源被永久移动到了新位置
304 Not Modified

400 Bad Request
401 
403 Forbidden 服务器已接收到请求，但拒绝执行
404 Not found

500 Internal Server Error
501 Not Implemented
502 Bad Gateway
```

参考：https://zh.wikipedia.org/wiki/HTTP%E7%8A%B6%E6%80%81%E7%A0%81#1xx%E6%B6%88%E6%81%AF

### header

#### General Header

##### Upgrade

提供一个机制，可以切换 protocol。

```
client 通过 Upgrade 列出希望使用的 ptorocol

server 返回新选定的 protocol， 返回码为 101

```

##### Content-Type
```
Content-Type: application/x-www-form-urlencoded
Content-Type: application/json
```

##### HSTS
```
Strict-Transport-Security: max-age=0

HTTP Strict Transport Security（通常简称为HSTS）是一个安全功能，它告诉浏览器只能通过HTTPS访问当前资源，而不是HTTP。

max-age=<expire-time>
设置在浏览器收到这个请求后的<expire-time>秒的时间内凡是访问这个域名下的请求都使用HTTPS请求。
```


#### Request Header

```
Host: www.w3.org
必须的参数。

User-Agent: CERN-LineMode/2.15 libwww/2.17b3

Location: http://www.w3.org/pub/WWW/People.html
重定向 

If-Modified-Since: Sat, 29 Oct 1994 19:43:31 GMT
假如请求的资源在该日期之后没有modify，则返回 304 ，不会反回 entity

```

#### Response Header

##### Cache-Control

```
Cache-Control: public, max-age=0
```


### Entity

#### Entity Header

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

#### Entity Body





### HTTP2.0和HTTP1.X相比的新特性

- tcp连接 复用
- header 压缩


### 参考

- http: https://tools.ietf.org/html/rfc2616#section-5