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

        NotificationCenter.default.addObserver(self, selector: #selector(updateUndoButtonsStatus), name: .NSUndoManagerDidUndoChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateUndoButtonsStatus), name: .NSUndoManagerDidRedoChange, object: nil)
    }

    private func synchronizeProject() {
        colorView.backgroundColor = project.color
        colorView.alpha = CGFloat(project.opacity)
        updateUndoButtonsStatus()
    }

    @objc private func updateUndoButtonsStatus() {
        undoButtonItem.isEnabled = undoManager?.canUndo ?? false
        redoButtonItem.isEnabled = undoManager?.canRedo ?? false
    }

    @IBAction func undoButtonAction(_ sender: Any) {
        undoManager?.undo()
        label.text = undoManager?.undoActionName
    }

    @IBAction func redoButtonAction(_ sender: Any) {
        undoManager?.redo()
        label.text = undoManager?.redoActionName
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
        })
        undoManager?.setActionName("Color")

        project.color = color
        synchronizeProject()
    }
}
