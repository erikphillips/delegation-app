//
//  TaskDetailViewController.swift
//  DelegationApp-macOS
//
//  Created by Erik Phillips on 3/13/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import Cocoa

class TaskDetailViewController: NSViewController {

    var user: User?
    var task: Task?
    
    @IBOutlet weak var titleTextField: NSTextField!
    @IBOutlet weak var teamTextField: NSTextField!
    @IBOutlet weak var assigneeTextField: NSTextField!
    @IBOutlet weak var originatorTextField: NSTextField!
    @IBOutlet weak var statusButton: NSPopUpButton!
    @IBOutlet weak var priorityButton: NSPopUpButton!
    @IBOutlet weak var descriptionTextView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.log("TaskDetailViewController viewDidLoad")
    }
    
    override func viewWillAppear() {
        Logger.log("TaskDetailViewController viewWillAppear")
        self.refresh()
    }
    
    func refresh() {
        if let task = task {
            self.titleTextField.stringValue = task.getTitle()
            self.teamTextField.stringValue = task.getTeamUID()
            self.assigneeTextField.stringValue = task.getAssigneeFullName()
            self.originatorTextField.stringValue = task.getOriginatorFullName()
            self.statusButton.selectItem(withTitle: task.getStatus())
            self.priorityButton.selectItem(withTitle: task.getPriority())
            self.descriptionTextView.string = task.getDescription()
        }
    }
    
    @IBAction func saveChangesBtnPressed(_ sender: Any) {
    }
    
    @IBAction func revertChangesBtnPressed(_ sender: Any) {
        self.refresh()
    }
    
}
