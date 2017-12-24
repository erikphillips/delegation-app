//
//  JoinTeamTableViewCell.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/16/17.
//  Copyright © 2017 Erik Phillips. All rights reserved.
//

import UIKit

class JoinTeamTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    var isCellSelected = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
