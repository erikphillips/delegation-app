//
//  SettingsTableViewController.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/14/17.
//  Copyright © 2017-2018 Erik Phillips. All rights reserved.
//

import UIKit
import Firebase

class SettingsTableViewController: UITableViewController {
    
    var user: User?
    
    @IBOutlet weak var applicationVersionLabel: UILabel!
    @IBOutlet weak var applicationBuildLabel: UILabel!
    
    @IBOutlet weak var settingsTableView: UITableView!
    @IBAction func settingsLogout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        self.performSegue(withIdentifier: "unwindToWelcomeView", sender: sender)
    }
    
    @IBAction func settingsDeleteAccount(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Delete Account", message: "Would you like to delete your account? This action is permanent and cannot be undone.", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            Logger.log("Cancel account deleteion button pressed.")
        }
        
        let destroyAction = UIAlertAction(title: "Delete Account", style: .destructive) { action in
            Logger.log("Delete account button pressed.")
            
            let secondaryAlertController = UIAlertController(title: "Delete Account", message: "Deleting the account will erase all information on regarding yourself and cannot be recovered. Are you sure you would like to proceed?", preferredStyle: .alert)
            
            let secondaryDeleteAction = UIAlertAction(title: "Delete Account", style: .destructive) { (action:UIAlertAction) in
                Logger.log("Secondary delete account button pressed.")
                FirebaseUtilities.deleteCurrentUserAccount(callback: {
                    [weak self] (status: Int) in
                    guard let this = self else { return }
                    
                    if status == 200 {
                        let deletionAlertController = UIAlertController(title: "Account Deleted", message: "Your account has been deleted successfully.", preferredStyle: .alert)
                        let deletionOKAction = UIAlertAction(title: "OK", style: .default) {
                            [weak self] action in
                            guard let this = self else { return }
                            Logger.log("OK button pressed, unwinding to welcome view.")
                            this.performSegue(withIdentifier: "unwindToWelcomeView", sender: sender)
                        }
                        deletionAlertController.addAction(deletionOKAction)
                        this.present(deletionAlertController, animated: true, completion: nil)
                    } else {
                        let deletionAlertController = UIAlertController(title: "Unsuccessful Account Deletion", message: "Your account has not been deleted.", preferredStyle: .alert)
                        let deletionOKAction = UIAlertAction(title: "OK", style: .default) { action in Logger.log("OK button pressed.") }
                        deletionAlertController.addAction(deletionOKAction)
                        this.present(deletionAlertController, animated: true, completion: nil)
                    }
                })
            }
            
            let secondaryCancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
                Logger.log("Secondary cancel account deletion button pressed.")
            }
            
            secondaryAlertController.addAction(secondaryDeleteAction)
            secondaryAlertController.addAction(secondaryCancelAction)
            self.present(secondaryAlertController, animated: true, completion:nil)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(destroyAction)
        
        self.present(alertController, animated: true)
    }
    
    @IBOutlet weak var settingsFirstname: UILabel!
    @IBOutlet weak var settingsLastname: UILabel!
    @IBOutlet weak var settingsEmailAddress: UILabel!
    @IBOutlet weak var settingsPhoneNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Logger.log("Settings TableView loaded...")
        
        let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let buildNumberString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String

        applicationVersionLabel.text = "Delegation Application v\(appVersionString)"
        applicationBuildLabel.text = "Build \(buildNumberString)"
        
        if let user = user {
            user.observers.observe(canary: self, callback: {
                (user: User) in
                
                Logger.log("Settings table view controller recieved user update")
                
                self.settingsFirstname.text = user.getFirstName()
                self.settingsLastname.text = user.getLastName()
                self.settingsEmailAddress.text = user.getEmailAddress()
                self.settingsPhoneNumber.text = user.getPhoneNumber()
                
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Logger.log("Settings TableView will appear...")
        
        if let user = user {
            self.settingsFirstname.text = user.getFirstName()
            self.settingsLastname.text = user.getLastName()
            self.settingsEmailAddress.text = user.getEmailAddress()
            self.settingsPhoneNumber.text = user.getPhoneNumber()
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
                return "User Account Management"
            }
        case 1:
            return "Team Management"
        case 2:
            return "Application Management"
        default:
            return nil
        }
    }
    
    @IBAction func unwindToSettingsTableView(segue: UIStoryboardSegue) { }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToWelcomeView" {
            Logger.log("unwindToWelcomeView segue called.")
        }
        
        if segue.identifier == "SettingsEditUserInfo" {
            if let dest = segue.destination as? UpdateAccountSettingsViewController {
                Logger.log("UpdateAccountSettingsViewController segue called.")
                dest.user = self.user
            }
        }
        
        if segue.identifier == "SettingsShowYourTeams" {
            if let dest = segue.destination as? SettingsTeamTableViewController {
                Logger.log("SettingsShowYourTeams segue called")
                dest.user = user
            }
        }
    }
    
}
