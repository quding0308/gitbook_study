## FSM (Finite State Machine) 有限状态机

在一个系统内有多个状态，用于表示多个状态、状态之间切换的动作的模型

- state
- event(action)

每当收到一个 event 后，根据当前的 state 切换到新的 state 


输出 = 当前状态 + 输入

### 伪代码实现

``` c
FSMEngine {

    var curStateId
    var curState

    // -1 no change 0 state changed
    func receiveInput(_ dict) -> Int

    func start()
}

FSMEvent {
    load = 0
    unload,
    systemCallback,
    pingCallback
}

FSMState {
    invalid,
    unloaded,
    loading,
    wifi,
    wwan,
    unreachable
}

State {
    // init
    func state()

    // receive event 
    func onEvent(event) -> FSMState?
}
```

### 状态图：

``` c
event\state	invalid	unloaded	loading	wifi	wwan	unreachable
    load		loading				
    unload		unload	unload	unload	unload	unload
systemCallback			loaded(3)	loaded(3)	loaded(3)	loaded(3)
pingCallback			loaded(3)	loaded(3)	loaded(3)	loaded(3)
```


| 左对齐 | 右对齐 | 居中对齐 |
| :----:| :----:| :----: |
| 单元格 | 单元格 | 单元格 |
| 单元格 | 单元格 | 单元格 |
