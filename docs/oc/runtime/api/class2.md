## 添加 Class、实例化对象

Adding Classes
```
objc_allocateClassPair
    Creates a new class and metaclass.
objc_disposeClassPair
    Destroys a class and its associated metaclass.
objc_registerClassPair
    Registers a class that was allocated using objc_allocateClassPair.
objc_duplicateClass
    Used by Foundation's Key-Value Observing.
```

Instantiating Classes
```
class_createInstance
    Creates an instance of a class, allocating memory for the class in the default malloc memory zone.
objc_constructInstance
    Creates an instance of a class at the specified location.
objc_destructInstance
    Destroys an instance of a class without freeing memory and removes any of its associated references.
```