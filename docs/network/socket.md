### api

client端：

``` c
// create socket
int fd = socket(AF_INET, SOCK_STREAM  , 0);
BOOL success = (fd!=-1);
int err;
struct sockaddr_in addr;

if (success) { // create success
    NSLog(@"socket success");
    memset(&addr, 0, sizeof(addr));
    addr.sin_len=sizeof(addr);
    addr.sin_family=AF_INET;
    addr.sin_addr.s_addr=INADDR_ANY;
    // 绑定客户端的 ip 与 一个端口
    err = bind(fd, (const struct sockaddr *)&addr, sizeof(addr));
    success=(err==0);
}

if (success) {
    struct sockaddr_in peeraddr;
    memset(&peeraddr, 0, sizeof(peeraddr));
    peeraddr.sin_len=sizeof(peeraddr);
    peeraddr.sin_family=AF_INET;
    peeraddr.sin_port=htons(1024);
    peeraddr.sin_addr.s_addr=inet_addr("172.16.10.120"); // 服务器地址
    socklen_t addrLen;
    addrLen =sizeof(peeraddr);

    // 与服务器连接，3次握手
    err = connect(fd, (struct sockaddr *)&peeraddr, addrLen);
    success = (err==0);
    if (success) {
        err = getsockname(fd, (struct sockaddr *)&addr, &addrLen);
        success = (err==0);
        if (success) {
            NSLog(@"connect success,local address:%s,port:%d",inet_ntoa(addr.sin_addr),ntohs(addr.sin_port));
            char buf[1024];
            do {
                printf("input message:");
                scanf("%s",buf);
                // 发送数据
                send(fd, buf, 1024, 0);
            } while (strcmp(buf, "exit")!=0);
        }
    } else{
        NSLog(@"connect failed");
    }
}
```

server端

``` c
int err;
int fd = socket(AF_INET, SOCK_STREAM  , 0);
BOOL success=(fd!=-1);

if (success) {
    NSLog(@"socket success");
    struct sockaddr_in addr;
    memset(&addr, 0, sizeof(addr));
    addr.sin_len=sizeof(addr);
    addr.sin_family=AF_INET;
    addr.sin_port=htons(1024);
    addr.sin_addr.s_addr=INADDR_ANY;
    err = bind(fd, (const struct sockaddr *)&addr, sizeof(addr));
    success=(err==0);
}

if (success) {
    NSLog(@"bind(绑定) success");
    err = listen(fd, 5);//开始监听
    success=(err==0);
}

if (success) {
    NSLog(@"listen success");
    while (true) {
        struct sockaddr_in peeraddr;
        int peerfd;
        socklen_t addrLen;
        addrLen = sizeof(peeraddr);
        NSLog(@"prepare accept");
        peerfd = accept(fd, (struct sockaddr *)&peeraddr, &addrLen);
        success = (peerfd!=-1);
        if (success) {
            NSLog(@"accept success,remote address:%s,port:%d",inet_ntoa(peeraddr.sin_addr),ntohs(peeraddr.sin_port));
            char buf[1024];
            ssize_t count;
            size_t len=sizeof(buf);
            do {
                count=recv(peerfd, buf, len, 0);
                NSString* str = [NSString stringWithCString:buf encoding:NSUTF8StringEncoding];
                NSLog(@"%@",str);
            } while (strcmp(buf, "exit")!=0);
        }
        close(peerfd);
    }
}
```