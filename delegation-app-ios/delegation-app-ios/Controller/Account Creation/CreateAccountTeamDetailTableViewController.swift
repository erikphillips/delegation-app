//
//  CreateAccountTeamDetailTableViewController.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 2/6/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import UIKit

class CreateAccountTeamDetailTableViewController: UITableViewController {

    var team: Team?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var memberCountLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let team = self.team {
            self.titleLabel.text = team.getTeamName()
            self.ownerLabel.text = team.getOwnerFullName()
            self.memberCountLabel.text = team.getMemberCount()
            self.descriptionTextView.text = team.getDescription()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
