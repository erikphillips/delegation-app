//
//  TeamTableViewCell.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 2/4/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import UIKit

class TeamTableViewCell: UITableViewCell {

    var team: Team?

    @IBOutlet weak var teamTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
