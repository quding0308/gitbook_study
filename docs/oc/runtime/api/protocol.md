## runtime api

``` java
objc_getProtocol
    Returns a specified protocol.
objc_copyProtocolList
    Returns an array of all the protocols known to the runtime.
objc_allocateProtocol
    Creates a new protocol instance.
objc_registerProtocol
    Registers a newly created protocol with the Objective-C runtime.
protocol_addMethodDescription
    Adds a method to a protocol.
protocol_addProtocol
    Adds a registered protocol to another protocol that is under construction.
protocol_addProperty
    Adds a property to a protocol that is under construction.
protocol_getName
    Returns a the name of a protocol.
protocol_isEqual
    Returns a Boolean value that indicates whether two protocols are equal.
protocol_copyMethodDescriptionList
    Returns an array of method descriptions of methods meeting a given specification for a given protocol.
protocol_getMethodDescription
    Returns a method description structure for a specified method of a given protocol.
protocol_copyPropertyList
    Returns an array of the properties declared by a protocol.
protocol_getProperty
    Returns the specified property of a given protocol.
protocol_copyProtocolList
    Returns an array of the protocols adopted by a protocol.
protocol_conformsToProtocol
    Returns a Boolean value that indicates whether one protocol conforms to another protocol.
```

## 概述

在 runtime 阶段，protocol 都会存储在全局的 hashmap 中，key 为 name， value 为 Protocol 

protocol 中用于声明 method 和 property ，只是声明，没有对应实现。

声明 property 时，编译阶段不会生成 setter 和 getter 方法。


``` java
struct protocol_t : objc_object {
    const char *mangledName;
    struct protocol_list_t *protocols;
    method_list_t *instanceMethods; // required instance methods
    method_list_t *classMethods;
    method_list_t *optionalInstanceMethods; // optional instance methods
    method_list_t *optionalClassMethods;
    property_list_t *instanceProperties;    // instance property
}

```
