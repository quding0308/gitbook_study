## Library

在 App 启动时，首先会遍历所有的 images ，存储在链表中。

```
// 遍历链表 获取 count 和 链表的 head
objc_copyImageNames
    Returns the names of all the loaded Objective-C frameworks and dynamic libraries.

// 根据 class 反查 images
class_getImageName
    Returns the name of the dynamic library a class originated from.

objc_copyClassNamesForImage
    Returns the names of all the classes within a specified library or framework.
```