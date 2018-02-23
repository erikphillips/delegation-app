//
//  TasksTableViewCell.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/15/17.
//  Copyright © 2017-2018 Erik Phillips. All rights reserved.
//

import UIKit

class TasksTableViewCell: UITableViewCell {

    var task: Task?
    
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskPriorityLabel: UILabel!
    @IBOutlet weak var taskTeamNameLabel: UILabel!
    @IBOutlet weak var taskAssignedLabel: UILabel!
    @IBOutlet weak var taskStatusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        Logger.log("Task cell awake from nib")

//        if let task = task {
//            taskNameLabel.text = task.getTitle()
//            taskPriorityLabel.text = task.getPriority()
//            taskTeamNameLabel.text = task.getTeamUID()
//            taskAssignedLabel.text = task.getAssigneeUUID()
//            taskStatusLabel.text = task.getStatus()
//        }
//            self.taskNameLabel.text = task.getTitle()
//            self.taskAssignedLabel.text = task.getAssigneeUUID()
//            self.taskTeamNameLabel.text = task.getTeamUID()
//            self.taskPriorityLabel.text = task.getPriority()
//            self.taskStatusLabel.text = task.getStatus()
//            
//            let taskUpdateHandler = {
//                [weak self] (task: Task) in
//                guard let this = self else { return }
//                this.taskNameLabel.text = task.getTitle()
//                this.taskAssignedLabel.text = task.getAssigneeUUID()
//                this.taskTeamNameLabel.text = task.getTeamUID()
//                this.taskPriorityLabel.text = task.getPriority()
//                this.taskStatusLabel.text = task.getStatus()
//            }
//            
//            task.observers.observe(canary: self, callback: taskUpdateHandler)
//        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
