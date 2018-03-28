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
    
    var selectedNewTeam: Team?
    var selectedNewAssignee: User?
    
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
    
    func reloadViewElements() {
        if let name = self.selectedNewTeam?.getGUID() {
            self.teamTextField.stringValue = name
        }
        
        if let name = self.selectedNewAssignee?.getFullName() {
            self.assigneeTextField.stringValue = name
        }
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
        self.task?.updateTask(title: self.titleTextField.stringValue, priority: self.priorityButton.selectedItem?.title, description: self.descriptionTextView.string, status: self.statusButton.selectedItem?.title)
        
        if let newAssignee = self.selectedNewAssignee {
            self.task?.changeAssignee(to: newAssignee.getUUID())
            self.selectedNewAssignee = nil
        }

        if let newTeam = self.selectedNewTeam {
            self.task?.changeTeam(to: newTeam.getGUID())
            self.selectedNewTeam = nil
        }
    }
    
    @IBAction func revertChangesBtnPressed(_ sender: Any) {
        self.refresh()
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier?.rawValue == "ShowTaskSelectAssigneeSegue" {
            if let dest = segue.destinationController as? TaskDetailSelectAssigneeViewController {
                Logger.log("ShowTaskSelectAssigneeSegue called")
                dest.task = self.task
                dest.rootViewController = self
            }
        }
        
        if segue.identifier?.rawValue == "ShowTaskSelectTeamSegue" {
            if let dest = segue.destinationController as? TaskDetailSelectTeamViewController {
                Logger.log("ShowTaskSelectTeamSegue called")
                dest.rootViewController = self
            }
        }
    }
    
}
