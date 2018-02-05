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
        
        let teamUpdateHandler = {
            [weak self] (team: Team) in
            guard let this = self else {return}
            
            if let team = this.team {
                Logger.log("team table view recieved team update for guid=\(team.getGUID())")
                this.teamTitleLabel.text = team.getTeamName()
            }
        }
        
        if let team = team {
            Logger.log("team cell awoken - \(team.getTeamName())")
            self.teamTitleLabel.text = team.getTeamName()
            team.observers.observe(canary: self, callback: teamUpdateHandler)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
