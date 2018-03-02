//
//  TeamSpecificTaskTableViewCell.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 2/22/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import UIKit

class TeamSpecificTaskTableViewCell: UITableViewCell {

    var task: Task?
    
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var assigneeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
