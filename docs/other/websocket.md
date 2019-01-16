## WebSocket

### 介绍

WebSocket 是HTML5一种新的协议。它实现了浏览器与服务器全双工通信(full-duplex)。一开始的握手需要借助HTTP请求完成。

开发 WebSocket 的目的是为了 **替代轮询，使网页有即时通讯的能力** 

轮询的缺点：

- 会导致不必要的请求，浪费资源。即时没有消息，也需要轮询
- 每次一轮询都有 请求和应答，header 带的消息比较多，也会浪费资源。
- 如果有消息，没法即时获取。

WebSocket 特点：

- 与 http 一样，都属于应用层协议



在WebSocket API中，浏览器和服务器只需要完成一次握手，两者之间就直接可以创建持久性的连接，并进行双向数据传输。

Websocket使用ws或wss的统一资源标志符，类似于HTTPS，其中wss表示在TLS之上的Websocket。如：

```
ws://example.com/wsapi
wss://secure.example.com/
```

Websocket使用和 HTTP 相同的 TCP 端口，可以绕过大多数防火墙的限制。默认情况下，Websocket协议使用80端口；运行在TLS之上时，默认使用443端口。

### 握手

WebSocket 是独立的、创建在 TCP 上的协议。

Websocket 通过 HTTP/1.1 协议的101状态码进行握手。

握手过程：

Client
```
GET / HTTP/1.1
Upgrade: websocket
Connection: Upgrade
Host: example.com
Origin: http://example.com
Sec-WebSocket-Key: sN9cRrP/n9NdMgdcy2VJFQ==
Sec-WebSocket-Version: 13
```

Server
```
HTTP/1.1 101 Switching Protocols
Upgrade: websocket
Connection: Upgrade
Sec-WebSocket-Accept: fFBooB7FAkLlXgRSz0BT3v4hq5s=
Sec-WebSocket-Location: ws://example.com/
```


### 参考
- 官方文档：https://tools.ietf.org/html/rfc6455
- http://www.ruanyifeng.com/blog/2017/05/websocket.html