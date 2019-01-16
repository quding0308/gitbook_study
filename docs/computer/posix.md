## POSIX

Portable Operating System Interface Of UNIX   （Portable  可移植的）

POSIX 表示 可移植操作系统接口

POSIX标准 定义了操作系统应该为应用程序提供的接口标准。

维基百科：

https://zh.wikipedia.org/wiki/%E5%8F%AF%E7%A7%BB%E6%A4%8D%E6%93%8D%E4%BD%9C%E7%B3%BB%E7%BB%9F%E6%8E%A5%E5%8F%A3


POSIX API文档:

http://pubs.opengroup.org/onlinepubs/9699919799/


POSIX 定义了一系列 header，在 header 中定义了函数原型(function prototypes)、constant、common structure、宏macro，不同的操作系统会有对应的实现。


### pthread.h

定义了POSIX的线程标准，定义了一套API 用于创建、操作线程

``` c
#include <pthread.h>
```

参考：https://zh.wikipedia.org/wiki/POSIX%E7%BA%BF%E7%A8%8B

### math.h

``` c
#include <math.h>
```

### sys/mman.h

``` c
#include <sys/mman.h>

mmap(void *, size_t, int, int, int, off_t)

```

内存管理

### sys/socket.h

``` c
#include <sys/socket.h>

// 监听
int listen(int, int)

bind

// client
int socket(int, int, int)
int connect(int, const struct sockaddr *, socklen_t)


```

socket 编程

### dirent.h

``` c 
#include <dirent.h>

DIR *opendir(const char *)

```

对目录的操作



### string.h

``` c
#include <string.h>
```

对字符串操作