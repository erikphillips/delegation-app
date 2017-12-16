//
//  TasksTableViewCell.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/15/17.
//  Copyright © 2017 Erik Phillips. All rights reserved.
//

import UIKit

class TasksTableViewCell: UITableViewCell {

    var task: Task?
    
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskPriorityLabel: UILabel!
    @IBOutlet weak var taskTeamNameLabel: UILabel!
    @IBOutlet weak var taskAssignedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        if let task = task {
            taskNameLabel.text = task.getName()
            taskPriorityLabel.text = String(task.getPriority())
            taskTeamNameLabel.text = task.getTeamName()
            taskAssignedLabel.text = String(describing: task.getAssignedUserNames())
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
