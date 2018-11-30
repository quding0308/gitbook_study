### RxCocoa

#### Binder

Observer ，具有以下特征：

1. 不处理error
2. 默认 在主线程执行 

Binder 主要用来给 View 增加 Observer，方便 在主线程中更新ui，并且不处理error，例如：

``` Swift
extension Reactive where Base: UITabBarItem {
    public var badgeValue: Binder<String?> {
        return Binder(self.base) { tabBarItem, badgeValue in
            tabBarItem.badgeValue = badgeValue
        }
    }   
} 
```

#### Driver

Observable sequence，具有以下特征：

1. 不会失败(如果失败，会返回有默认值)
2. 在主线程处理 observer
3. 共享状态变化，有 shareReplay(1) 的行为

Driver 主要最适合用来更新 View

``` Swift
let observable = Observable.just(1)
let driver = observable.asDriver(onErrorJustReturn: 0)
//asDriver() 等价于
let driver = observable
  .observeOn(MainScheduler.instance)       // 主线程监听
  .catchErrorJustReturn(onErrorJustReturn) // 无法产生错误
  .share(replay: 1, scope: .whileConnected)// 共享状态变化

```

#### ControlProperty

既是Observable，又是 Observer，用于封装UI控件的属性，具有一下特点：

1. 不产生error
2. 订阅 和 监听 都在 主线程
3. 共享状态变化，有 shareReplay(1) 的行为
4. 有初始值

使用：

``` Swift
extension Reactive where Base: UITextField {
    public var text: ControlProperty<String?> {
        return base.rx.controlPropertyWithDefaultEvents(
            getter: { textField in
                textField.text
            },
            setter: { textField, value in
                // This check is important because setting text value always clears control state
                // including marked text selection which is imporant for proper input 
                // when IME input method is used.
                if textField.text != value {
                    textField.text = value
                }
            }
        )
    }
}

// as observable
textField.rx.text.bind(to: label.rx.text)

// as observer
let observable = Observable.from(["1"])
observable.bind(to: textField.rx.text)
```

#### ControlEvent

Observable，用于封装 UI控件的事件，具有以下特点：

1. 不产生error
2. 订阅 和 监听 都在 主线程
3. 共享状态变化
4. 没有初始值

使用：

``` Swift
extension Reactive where Base: UIButton {    
    /// Reactive wrapper for `TouchUpInside` control event.
    public var tap: ControlEvent<Void> {
        return controlEvent(.touchUpInside)
    }
}

// as observable
btn.rx.tap.subscribe(onNext: {
    print("tapped")
}).disposed(by: disposebag)
        


```

#### Signal


#### Bag

用于回收

