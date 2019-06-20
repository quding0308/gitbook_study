## 概述

```


typedef uintptr_t protocol_ref_t;  // protocol_t *, but unremapped

// 存放的是 protocol_ref_t
struct protocol_list_t 

class protocol_array_t : public list_array_tt<protocol_ref_t, protocol_list_t> {

}

```

```
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