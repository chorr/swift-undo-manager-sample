#  UndoManager Sample

Foundation 프레임웍 [Task Management](https://developer.apple.com/documentation/foundation/task_management) 항목으로 분류되어 있으며, 
[UIResponder](https://developer.apple.com/documentation/uikit/uiresponder) 클래스 속성에 getter가 포함되어 있다. 

## 주로 사용되는 API
```swift
undoManager.registerUndo(withTarget: self, handler: { (targetSelf) in
    // TODO
})

undoManager.canUndo
undoManager.canRedo

undoManager.undo()
undoManager.redo()

undoManager.setActionName("color")
undoManager.undoActionName
undoManager.undoMenuItemTitle
undoManager.undoMenuTitle(forUndoActionName: "color")

undoManager.levelsOfUndo = 10
```

## Notification 활용 가능
```swift
NotificationCenter.default.addObserver(self, selector: #selector(updateUndoButtonsStatus), name: .NSUndoManagerDidUndoChange, object: nil)
NotificationCenter.default.addObserver(self, selector: #selector(updateUndoButtonsStatus), name: .NSUndoManagerDidRedoChange, object: nil)
```
