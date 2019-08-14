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

## Undo 로직 분리
### AS-IS
```swift
func setColorChangeAction(_ sender: Any) {
    project.color = sender.value
    synchronizeProject()
}
```

### TO-BE
```swift
func setColorChangeAction(_ sender: Any) {
	setProjectColor(sender.value)
}

func setProjectColor(_ color: UIColor) {
	// TODO: Undo 로직 등록 필요.

    project.color = color
    synchronizeProject()
}
```

## Undo 로직 패턴1
단순하게 속성 변경이 발생하는 경우.
```swift
func setProjectColor(_ color: UIColor) {
    let oldColor = project.color
    undoManager?.registerUndo(withTarget: self, handler: { (targetSelf) in
        targetSelf.setProjectColor(oldColor)
        // Undo 실행 후 UI 업데이트 필요하다면?
    })
    undoManager?.setActionName("Color : \(project.colorName)")

    project.color = color
    synchronizeProject()
}
```

## Undo 로직 패턴2
UISlider 같이 지속적으로 값이 변경될 경우 대응 패턴.
```swift
@IBAction func sliderValueChangedAction(_ slider: UISlider, event: UIEvent) {
    guard let touchEvent = event.allTouches?.first else {
        return
    }
    if touchEvent.phase == .began {
        // Undo 로직 등록.
        setProjectOpacity(slider.value, oldOpacity: project.opacity)
    } else {
        // UI 업데이트만 진행.
        setProjectOpacity(slider.value, isRegisterUndo: false)
    }
}

func setProjectOpacity(_ opacity: Float, oldOpacity: Float? = nil, isRegisterUndo: Bool = true) {
    if isRegisterUndo {
        let oldOpacity = oldOpacity ?? project.opacity
        undoManager?.registerUndo(withTarget: self, handler: { (targetSelf) in
            targetSelf.setProjectOpacity(oldOpacity)
            // Undo 실행 후 UI 즉시 업데이트.
            targetSelf.slider.value = oldOpacity
        })
        undoManager?.setActionName("Opacity : \(project.opacity)")
    }

    project.opacity = opacity
    synchronizeProject()
}

```

## 기기의 Shake 동작으로 Undo 연동
### Application Main
```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    application.applicationSupportsShakeToEdit = true
    return true
}
```

### View Controller
```swift
override var canBecomeFirstResponder: Bool {
    return true
}

override func viewDidAppear(_ animated: Bool) {
	becomeFirstResponder()
}

override func viewWillDisappear(_ animated: Bool) {
	resignFirstResponder()	
}	
```
