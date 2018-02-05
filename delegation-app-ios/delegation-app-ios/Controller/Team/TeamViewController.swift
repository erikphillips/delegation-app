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
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TeamsEmbeddedSegue" {
            if let dest = segue.destination as? TeamTableViewController {
                Logger.log("received TeamsEmbeddedSegue")
                dest.user = user
            }
        }
    }

}
