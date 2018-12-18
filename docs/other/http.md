## http

### Request

```
<method> <request-URL> <version>
<headers>

<entity-body>


Content-Type: application/x-www-form-urlencoded
Content-Type: application/json


POST http://www.example.com HTTP/1.1
Content-Type: application/x-www-form-urlencoded;charset=utf-8

title=test&sub%5B%5D=1&sub%5B%5D=2&sub%5B%5D=3
```


### Response

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

### 状态码

参考：https://zh.wikipedia.org/wiki/HTTP%E7%8A%B6%E6%80%81%E7%A0%81#1xx%E6%B6%88%E6%81%AF

```
1xx消息——请求已被服务器接收，继续处理
2xx成功——请求已成功被服务器接收、理解、并接受
3xx重定向——需要后续操作才能完成这一请求
4xx请求错误——请求含有词法错误或者无法被执行
5xx服务器错误——服务器在处理某个正确请求时发生错误

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

### HTTP2.0和HTTP1.X相比的新特性

- tcp连接 复用
- header 压缩