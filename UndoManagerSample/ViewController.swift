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

    override func loadView() {
        super.loadView()
        segmentedControl.selectedSegmentIndex = 0
        label.text = ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        synchronizeProject()
        updateUndoButtonsStatus()

//        NotificationCenter.default.addObserver(self, selector: #selector(updateUndoButtonsStatus), name: .NSUndoManagerDidUndoChange, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(updateUndoButtonsStatus), name: .NSUndoManagerDidRedoChange, object: nil)
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
        setColorViewBackgroundColor(color)
    }
}

// MARK: - Undo 동작을 위한 로직

extension ViewController {
    private func setColorViewBackgroundColor(_ color: UIColor) {
        let oldColor = project.color
        undoManager?.registerUndo(withTarget: self, handler: { (targetSelf) in
            targetSelf.setColorViewBackgroundColor(oldColor)
            targetSelf.segmentedControl.selectedSegmentIndex = targetSelf.colors.index(of: oldColor) ?? 0
        })
        undoManager?.setActionName("Color : \(project.colorName)")

        project.color = color
        synchronizeProject()
    }
}
