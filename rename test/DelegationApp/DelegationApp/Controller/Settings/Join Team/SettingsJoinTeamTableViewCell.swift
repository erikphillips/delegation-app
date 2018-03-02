//
//  SettingsJoinTeamTableViewCell.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 1/8/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import UIKit

class SettingsJoinTeamTableViewCell: UITableViewCell {

    var team: Team?
    var isCellSelected = false
    
    @IBOutlet weak var teamTitleLabel: UILabel!
    @IBOutlet weak var checkmarkImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
