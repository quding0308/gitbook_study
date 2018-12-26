## 其他 api

Using Objective-C Language Features
```
objc_enumerationMutation
    Inserted by the compiler when a mutation is detected during a foreach iteration.
objc_setEnumerationMutationHandler
    Sets the current mutation handler.
imp_implementationWithBlock
    Creates a pointer to a function that calls the specified block when the method is called.
imp_getBlock
    Returns the block associated with an IMP that was created using imp_implementationWithBlock.
imp_removeBlock
    Disassociates a block from an IMP that was created using imp_implementationWithBlock, and releases the copy of the block that was created.
objc_loadWeak
    Loads the object referenced by a weak pointer and returns it.
objc_storeWeak
    Stores a new value in a __weak variable.
```