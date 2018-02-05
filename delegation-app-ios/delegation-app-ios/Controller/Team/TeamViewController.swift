//
//  TeamViewController.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/15/17.
//  Copyright © 2017-2018 Erik Phillips. All rights reserved.
//

import UIKit

class TeamViewController: UIViewController {

    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.log("team view controller loaded")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func unwindToTeamsTableView(segue: UIStoryboardSegue) { }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TeamsEmbeddedSegue" {
            if let dest = segue.destination as? TeamTableViewController {
                Logger.log("received TeamsEmbeddedSegue")
                dest.user = user
            }
        }
        
        if segue.identifier == "ShowCreateTeamView" {
            if let dest = segue.destination as? CreateNewTeamViewController {
                Logger.log("recieved ShowCreateTeamView segue")
                dest.user = user
            }
        }
    }

}
