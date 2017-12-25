//
//  SettingsTableViewController.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/14/17.
//  Copyright © 2017 Erik Phillips. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    var user: User?
    
    @IBOutlet weak var settingsTableView: UITableView!
    @IBAction func settingsLogout(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToWelcomeView", sender: sender)
    }
    
    @IBOutlet weak var settingsFirstname: UILabel!
    @IBOutlet weak var settingsLastname: UILabel!
    @IBOutlet weak var settingsEmailAddress: UILabel!
    @IBOutlet weak var settingsPhoneNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Settings TableView loaded...")
        
        if let user = user {
            settingsFirstname.text = user.getFirstName()
            settingsLastname.text = user.getLastName()
            settingsEmailAddress.text = user.getEmailAddress()
            settingsPhoneNumber.text = user.getPhoneNumber()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            if let user = user {
                return user.getFullName()
            } else {
                return "<account_fullname>"
            }
        case 1:
            return "Teams"
        default:
            return nil
        }
    }
    
    @IBAction func unwindToSettingsTableView(segue: UIStoryboardSegue) { }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToWelcomeView" {
            print("unwindToWelcomeView segue called.")
        }
        
        if segue.identifier == "SettingsEditUserInfo" {
            if let dest = segue.destination as? UpdateAccountSettingsViewController {
                dest.user = self.user
            }
        }
    }
    
}
