# Notifier
A simple way to present notification while app IS ACTIVE


## How To Use？
Just need one line 

```
Notifier.shared.showNotifier(title: "您有一条新消息", body: "@这是什么鬼\(i)", withObject:"\(i)", onTapNotifier: { (obj) in
    print("onTapNotifier----object:\(obj)")
})
```
