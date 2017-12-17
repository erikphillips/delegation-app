//
//  SettingsViewController.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/13/17.
//  Copyright © 2017 Erik Phillips. All rights reserved.
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
                print("setting embeded view user:")
                print(self.user)
                print(self.user?.getFullName())
                dest.user = self.user
            }
        }
    }

}
