## class

Working with Classes
```
class_getName
    Returns the name of a class.
class_getSuperclass
    Returns the superclass of a class.
class_isMetaClass
    Returns a Boolean value that indicates whether a class object is a metaclass.
class_getInstanceSize
    Returns the size of instances of a class.
class_getInstanceVariable
    Returns the Ivar for a specified instance variable of a given class.
class_getClassVariable
    Returns the Ivar for a specified class variable of a given class.
class_addIvar
    Adds a new instance variable to a class.
class_copyIvarList
    Describes the instance variables declared by a class.
class_getIvarLayout
    Returns a description of the Ivar layout for a given class.
class_setIvarLayout
    Sets the Ivar layout for a given class.
class_getWeakIvarLayout
    Returns a description of the layout of weak Ivars for a given class.
class_setWeakIvarLayout
    Sets the layout for weak Ivars for a given class.
class_getProperty
    Returns a property with a given name of a given class.
class_copyPropertyList
    Describes the properties declared by a class.
class_addMethod
    Adds a new method to a class with a given name and implementation.
class_getInstanceMethod
    Returns a specified instance method for a given class.
class_getClassMethod
    Returns a pointer to the data structure describing a given class method for a given class.
class_copyMethodList
    Describes the instance methods implemented by a class.
class_replaceMethod
    Replaces the implementation of a method for a given class.
class_getMethodImplementation
    Returns the function pointer that would be called if a particular message were sent to an instance of a class.
class_getMethodImplementation_stret
    Returns the function pointer that would be called if a particular message were sent to an instance of a class.
class_respondsToSelector
    Returns a Boolean value that indicates whether instances of a class respond to a particular selector.
class_addProtocol
    Adds a protocol to a class.
class_addProperty
    Adds a property to a class.
class_replaceProperty
    Replace a property of a class.
class_conformsToProtocol
    Returns a Boolean value that indicates whether a class conforms to a given protocol.
class_copyProtocolList
    Describes the protocols adopted by a class.
class_getVersion
    Returns the version number of a class definition.
class_setVersion
    Sets the version number of a class definition.
objc_getFutureClass
    Used by CoreFoundation's toll-free bridging.
objc_setFutureClass
    Used by CoreFoundation's toll-free bridging.
```

Obtaining Class Definitions
```
objc_getClassList
    Obtains the list of registered class definitions.
objc_copyClassList
    Creates and returns a list of pointers to all registered class definitions.
objc_lookUpClass
    Returns the class definition of a specified class.
objc_getClass
    Returns the class definition of a specified class.
objc_getRequiredClass
    Returns the class definition of a specified class.
objc_getMetaClass
    Returns the metaclass definition of a specified class.
```
