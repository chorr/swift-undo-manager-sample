//
//  ViewController.swift
//  UndoManagerSample
//
//  Created by Jeon Hyuncheol on 13/08/2019.
//  Copyright © 2019 chorr.net. All rights reserved.
//

import UIKit

struct Project {
    var color: UIColor = .black
    var opacity: Float = 1

    var colorName: String {
        switch self.color {
        case .red:
            return "Red"
        case .green:
            return "Green"
        case .blue:
            return "Blue"
        default:
            return "Black"
        }
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var undoButtonItem: UIBarButtonItem!
    @IBOutlet weak var redoButtonItem: UIBarButtonItem!
    @IBOutlet weak var label: UILabel!

    private var project: Project = Project()
    private let colors: [UIColor] = [.black, .red, .green, .blue]

    override var canBecomeFirstResponder: Bool {
        return true
    }

    override func loadView() {
        super.loadView()
        segmentedControl.selectedSegmentIndex = 0
        label.text = ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        synchronizeProject()
        updateUndoButtonsStatus()

        // Notification 예시.
//        NotificationCenter.default.addObserver(self, selector: #selector(updateUndoButtonsStatus), name: .NSUndoManagerDidUndoChange, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(updateUndoButtonsStatus), name: .NSUndoManagerDidRedoChange, object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        undoManager?.levelsOfUndo = 10
        becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resignFirstResponder()
    }

    private func synchronizeProject() {
        colorView.backgroundColor = project.color
        colorView.alpha = CGFloat(project.opacity)
        updateUndoButtonsStatus()
    }

    @objc private func updateUndoButtonsStatus() {
        DispatchQueue.main.async {
            self.undoButtonItem.isEnabled = self.undoManager?.canUndo ?? false
            self.redoButtonItem.isEnabled = self.undoManager?.canRedo ?? false
        }
    }

    @IBAction func undoButtonAction(_ sender: Any) {
        label.text = undoManager?.undoMenuItemTitle
        undoManager?.undo()
    }

    @IBAction func redoButtonAction(_ sender: Any) {
        label.text = undoManager?.redoMenuItemTitle
        undoManager?.redo()
    }

    @IBAction func segmentedControlValueChangedAction(_ sender: UISegmentedControl) {
        let color = colors[sender.selectedSegmentIndex]
        setProjectColor(color)
    }

    @IBAction func sliderValueChangedAction(_ slider: UISlider, event: UIEvent) {
        guard let _ = event.allTouches?.first else {
            return
        }
        project.opacity = slider.value
        synchronizeProject()
    }
}

// MARK: - Undo 동작을 위한 로직

extension ViewController {
    private func setProjectColor(_ color: UIColor) {
        let oldColor = project.color
        undoManager?.registerUndo(withTarget: self, handler: { (targetSelf) in
            targetSelf.setProjectColor(oldColor)
            // Undo 실행 후 UI 즉시 업데이트.
            targetSelf.segmentedControl.selectedSegmentIndex = targetSelf.colors.index(of: oldColor) ?? 0
        })
        undoManager?.setActionName("Color : \(project.colorName)")

        project.color = color
        synchronizeProject()
    }
}
