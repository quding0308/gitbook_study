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

### 发送数据

WebSocket 通过数据帧(Data Frame)的方式发送数据。

客户端发送的数据帧都要经过掩码处理，服务端发送的所有数据帧都不能经过掩码处理。否则对方需要发送关闭帧。

一个帧包含一个帧类型的标识码，一个负载长度，和负载。负载包括扩展内容和应用内容。

RFC6455中定义的帧类型如下所示：
```
1）Opcode == 0 继续：
表示此帧是一个继续帧，需要拼接在上一个收到的帧之后，来组成一个完整的消息。由于这种解析特性，非控制帧的发送和接收必须是相同的顺序。
2）Opcode == 1 文本帧。
3）Opcode == 2 二进制帧。
5）Opcode == 8 关闭连接（控制帧）：
此帧可能会包含内容，以表示关闭连接的原因。通信的某一方发送此帧来关闭WebSocket连接，收到此帧的一方如果之前没有发送此帧，则需要发送一个同样的关闭帧以确认关闭。如果双方同时发送此帧，则双方都需要发送回应的关闭帧。理想情况服务端在确认WebSocket连接关闭后，关闭相应的TCP连接，而客户端需要等待服务端关闭此TCP连接，但客户端在某些情况下也可以关闭TCP连接。
6）Opcode == 9 Ping：
类似于心跳，一方收到Ping，应当立即发送Pong作为响应。
7）Opcode == 10 Pong：
如果通信一方并没有发送Ping，但是收到了Pong，并不要求它返回任何信息。Pong帧的内容应当和收到的Ping相同。可能会出现一方收到很多的Ping，但是只需要响应最近的那一次就可以了。
```

### 参考
- https://tools.ietf.org/html/rfc6455
- http://www.ruanyifeng.com/blog/2017/05/websocket.html
- http://www.52im.net/thread-1266-1-1.html
- http://www.52im.net/thread-1273-1-1.html