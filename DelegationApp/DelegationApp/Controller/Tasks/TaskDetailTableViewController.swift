//
//  TaskDetailTableViewController.swift
//  DelegationApp
//
//  Created by Erik Phillips on 2/5/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import UIKit

class TaskDetailTableViewController: UITableViewController {

    var task: Task?
    private var currentlyEditing = false
    private var unsavedChanges = false
    
    var selectedAsssignee: User?
    private var assignees: [User]?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var assigneeLabel: UILabel!
    @IBOutlet weak var originatorLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var assigneeActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var teamActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let task = task {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit Task", style: UIBarButtonItemStyle.plain, target: self, action: #selector(startEditing(sender:)))
            
            self.titleLabel.text = task.getTitle()
            self.statusLabel.text = task.getStatus()
            self.priorityLabel.text = task.getPriority()
            self.assigneeLabel.text = task.getAssigneeFullName()
            self.originatorLabel.text = task.getOriginatorFullName()
            self.teamLabel.text = task.getTeamUID()
            self.descriptionTextView.text = task.getDescription()
            
            let taskUpdateOccurred = {
                [weak self] (task: Task) in
                guard let this = self else { return }
                
                Logger.log("TaskDetailTableViewController received task update")
                
                this.titleLabel.text = task.getTitle()
                this.statusLabel.text = task.getStatus()
                this.priorityLabel.text = task.getPriority()
                this.assigneeLabel.text = task.getAssigneeFullName()
                this.originatorLabel.text = task.getAssigneeFullName()
                this.teamLabel.text = task.getTeamUID()
                this.descriptionTextView.text = task.getDescription()
            }
            
            task.observers.observe(canary: self, callback: taskUpdateOccurred)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let assignee = self.selectedAsssignee {
            Logger.log("settings new selected assignee label")
            self.assigneeLabel.text = assignee.getFullName()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParentViewController {
            if self.unsavedChanges {
                Logger.log("unsaved changes should be saved", event: .warning)
                
                // TODO: Need to add change assignee and team
//                let task = self.task
//                let taskPayload = [
//                    "title": self.titleLabel.text,
//                    "priority": self.priorityLabel.text,
//                    "description": self.descriptionTextView.text,
//                    "status": self.statusLabel.text,
//                ]
//
//                let alertController = UIAlertController(title: "Save Task Changes?", message: nil, preferredStyle: .alert)
//                let cancelAction = UIAlertAction(title: "Don't Save", style: .cancel, handler: nil)
//                let saveAction = UIAlertAction(title: "Save", style: .default) { [task, taskPayload] (action: UIAlertAction) in
//                    Logger.log("You've pressed SAVE button");
//                    task?.updateTask(title: taskPayload["title"] ?? nil,
//                                     priority: taskPayload["priority"] ?? nil,
//                                     description: taskPayload["description"] ?? nil,
//                                     status: taskPayload["status"] ?? nil)
//                }
//
//                alertController.addAction(cancelAction)
//                alertController.addAction(saveAction)
//                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @objc func startEditing(sender: AnyObject) {
        Logger.log("startEditing button pressed")
        self.toggleEditing()
    }
    
    @objc func endEditing(sender: AnyObject) {
        Logger.log("endEditing button pressed, updating task")
        self.toggleEditing()
        self.task?.updateTask(title: self.titleLabel.text,
                              priority: self.priorityLabel.text,
                              description: self.descriptionTextView.text,
                              status: self.statusLabel.text)
        
        if let newAssignee = self.selectedAsssignee {
            self.task?.changeAssignee(to: newAssignee.getUUID())
        }
    }
    
    func toggleEditing() {
        self.currentlyEditing = !self.currentlyEditing
        
        if self.currentlyEditing {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save Changes", style: UIBarButtonItemStyle.plain, target: self, action: #selector(endEditing(sender:)))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit Task", style: UIBarButtonItemStyle.plain, target: self, action: #selector(startEditing(sender:)))
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.currentlyEditing && indexPath.section == 0 {
            self.unsavedChanges = true
            switch indexPath.row {
                case 0: self.editTitleRow()
                case 1: self.editStatusRow()
                case 2: self.editPriorityRow()
                case 3: self.editAssigneeRow()
                case 4: self.editTeamRow()
                case 5: self.editDescriptionRow()
                default: return
            }
        }
    }
    
    func editTitleRow() {
        Logger.log("editing title row")
        
        if let task = self.task {
            let alert = UIAlertController(title: "Enter a new task title:", message: nil, preferredStyle: .alert)
            alert.addTextField { [task] (textField) in textField.text = task.getTitle() }
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Update", style: .default, handler: {
                [weak self] (_) in
                guard let this = self else { return }
                this.titleLabel.text = alert.textFields?[0].text ?? this.titleLabel.text
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func editStatusRow() {
        Logger.log("editing status row")
        
        if let task = self.task {
            let alertSheet = UIAlertController(title: "Change status from current status of \(task.getStatus())", message: nil, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in Logger.log("Cancel button pressed.") }
            alertSheet.addAction(cancelAction)
            
            for status in ["Open", "Assigned", "In Progress", "Closed"] {
                if task.getStatus() != status {
                    let statusAction = UIAlertAction(title: status, style: .default) { [status, weak self] action in
                        guard let this = self else { return }
                        Logger.log("statusAction button pressed for status=\(status).")
                        this.statusLabel.text = status
                    }
                    
                    alertSheet.addAction(statusAction)
                }
            }
            
            self.present(alertSheet, animated: true)
        }
    }
    
    func editPriorityRow() {
        Logger.log("editing priority row")
        
        if let task = self.task {
            let alertSheet = UIAlertController(title: "Change priority from current priority of \(task.getPriority())", message: nil, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in Logger.log("Cancel button pressed.") }
            alertSheet.addAction(cancelAction)
            
            for priority in ["1", "2", "3", "4", "5"] {
                if task.getPriority() != priority {
                    let priorityAction = UIAlertAction(title: priority, style: .default) { [priority, weak self] action in
                        guard let this = self else { return }
                        Logger.log("priorityAction button pressed for priority=\(priority).")
                        this.priorityLabel.text = priority
                    }
                    alertSheet.addAction(priorityAction)
                }
            }
            
            self.present(alertSheet, animated: true)
        }
    }
    
    func editAssigneeRow() {
        Logger.log("editing assignee row")
        // "TaskDetailChangeAssigneeSegue"
        self.assigneeActivityIndicator.startAnimating()
        if let task = self.task {
            let team = Team(guid: task.getTeamUID())
            team.setupCallback = {
                [weak self, team] in
                guard let this = self else { return }
                
                this.assignees = []
                
                let dispatchGroup = DispatchGroup()
                
                for member in team.getMembers() {
                    dispatchGroup.enter()
                    let user = User(uuid: member)
                    user.setupCallback = {
                        [dispatchGroup] in
                        dispatchGroup.leave()
                    }
                    
                    this.assignees?.append(user)
                }
                
                dispatchGroup.notify(queue: .main) {
                    [weak this] in
                    guard let that = this else { return }
                    that.assigneeActivityIndicator.stopAnimating()
                    that.performSegue(withIdentifier: "TaskDetailChangeAssigneeSegue", sender: nil)
                }
            }
            
            
        }
    }
    
    func editTeamRow() {
        Logger.log("editing team row")
    }
    
    func editDescriptionRow() {
        Logger.log("editing description row")
    }
    
    @IBAction func unwindToTaskDetail(segue: UIStoryboardSegue) { }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TaskDetailChangeAssigneeSegue" {
            if let dest = segue.destination as? TaskChangeAssigneeTableViewController {
                dest.users = self.assignees
            }
        }
    }
}
