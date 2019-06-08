
## Send Message

```
objc_msgSend
    Sends a message with a simple return value to an instance of a class.
objc_msgSend_fpret
    Sends a message with a floating-point return value to an instance of a class.
objc_msgSend_stret
    Sends a message with a data-structure return value to an instance of a class.
objc_msgSendSuper
    Sends a message with a simple return value to the superclass of an instance of a class.
objc_msgSendSuper_stret
    Sends a message with a data-structure return value to the superclass of an instance of a class.
```

## 消息转发

分 3 个步骤：

1. 从当前类的缓存中查找 imp
2. 从方法列表查找消息，从父类递归查找
3. 消息转发

