//
//  TaskDetailTableViewController.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 2/5/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import UIKit

class TaskDetailTableViewController: UITableViewController {

    var task: Task?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var assigneeLabel: UILabel!
    @IBOutlet weak var originatorLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let task = task {
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
