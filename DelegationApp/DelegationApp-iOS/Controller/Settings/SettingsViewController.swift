//
//  SettingsViewController.swift
//  DelegationApp
//
//  Created by Erik Phillips on 12/13/17.
//  Copyright © 2017-2018 Erik Phillips. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    var user: User?
    
    @IBOutlet weak var settingsTableUIView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmbededView" {
            if let dest = segue.destination as? SettingsTableViewController {
                dest.user = self.user
            }
        }
    }

}
