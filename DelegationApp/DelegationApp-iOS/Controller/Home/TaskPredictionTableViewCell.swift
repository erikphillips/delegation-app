//
//  TaskPredictionTableViewCell.swift
//  DelegationApp-iOS
//
//  Created by Erik Phillips on 5/5/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import UIKit

class TaskPredictionTableViewCell: UITableViewCell {

    var task: Task?
    
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var taskPriorityLabel: UILabel!
    @IBOutlet weak var taskTeamNameLabel: UILabel!
    @IBOutlet weak var taskStatusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
