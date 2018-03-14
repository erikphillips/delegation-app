//
//  SettingsViewController.swift
//  DelegationApp-macOS
//
//  Created by Erik Phillips on 3/12/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import Cocoa

class SettingsViewController: NSViewController {
    
    var user: User?
    var allJoinableTeams: [Team]?

    @IBOutlet weak var firstnameTextField: NSTextField!
    @IBOutlet weak var lastnameTextField: NSTextField!
    @IBOutlet weak var emailTextField: NSTextField!
    @IBOutlet weak var phoneTextField: NSTextField!
    @IBOutlet weak var versionString: NSTextField!
    
    @IBOutlet weak var yourTeamsProgressIndicator: NSProgressIndicator!
    @IBOutlet weak var joinTeamsProgressIndicator: NSProgressIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the app version and build numbers
        let appVersionString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let buildNumberString: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        self.versionString.stringValue = "Version: \(appVersionString), Build: \(buildNumberString)"
        
        self.updateView()
    }
    
    func updateView() {
        if let user = self.user {
            self.firstnameTextField.stringValue = user.getFirstName()
            self.lastnameTextField.stringValue = user.getLastName()
            self.emailTextField.stringValue = user.getEmailAddress()
            self.phoneTextField.stringValue = user.getPhoneNumber()
        }
    }
    
    @IBAction func saveChangesBtnPressed(_ sender: Any) {
        Logger.log("saveChangesBtnPressed")
        
        var newFirstname: String? = nil
        var newLastname: String? = nil
        var newPhoneNumber: String? = nil
        var newEmailAddress: String? = nil
        var newPassword: String? = nil
        var newConfirmPassword: String? = nil
        
        if self.firstnameTextField.stringValue != self.user?.getFirstName() {
            newFirstname = self.firstnameTextField.stringValue
        }
        
        if self.lastnameTextField.stringValue != self.user?.getLastName() {
            newLastname = self.lastnameTextField.stringValue
        }
        
        if self.phoneTextField.stringValue != self.user?.getPhoneNumber() {
            newPhoneNumber = self.phoneTextField.stringValue
        }
        
        if self.emailTextField.stringValue != self.user?.getEmailAddress() {
            newEmailAddress = self.emailTextField.stringValue
            
            let verifyStatus = Utilities.validateEmail(newEmailAddress ?? Globals.UserGlobals.DEFAULT_EMAIL)
            if !verifyStatus.status {
                newEmailAddress = nil
                Logger.log("Invalid email address: \(verifyStatus.message)", event: .warning)
                // TODO: Display alert for invalid email address
            }
        }
        
        // TODO: Implement password text fields
//        if self.passwordTextField.text != Globals.UserGlobals.DEFAULT_PASSWORD
//            || self.confirmPasswordTextField.text != Globals.UserGlobals.DEFAULT_PASSWORD {
//
//            newPassword = self.passwordTextField.text
//            newConfirmPassword = self.confirmPasswordTextField.text
//
//            let verifyStatus = Utilities.validatePasswords(pswd: newPassword ?? Globals.UserGlobals.DEFAULT_PASSWORD,
//                                                           cnfrm: newConfirmPassword ?? Globals.UserGlobals.DEFAULT_PASSWORD)
//
//            if !verifyStatus.status {
//                newPassword = nil
//                newConfirmPassword = nil
//                Logger.log("invalid passwords: \(verifyStatus.message)")
//                // TODO: Display alert indicating invalid passwords
//            }
//        }
        
        if let user = self.user {
            Logger.log("Updating the current user with new information from settings update.")
            user.updateCurrentUser(firstname: newFirstname, lastname: newLastname, email: newEmailAddress, phone: newPhoneNumber, password: newPassword)
            let _ = self.displayAlert(title: "Account Information Updated Successfully", message: "")
        }
    }
    
    @IBAction func yourTeamsBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "ShowYourTeamsSegue"), sender: self)
    }
    
    @IBAction func joinTeamBtnPressed(_ sender: Any) {
        self.joinTeamsProgressIndicator.startAnimation(nil)
        FirebaseUtilities.fetchAllTeams { [weak self] (teams) in
            guard let this = self else { return }
            
            if let user = this.user {
                for team in teams {
                    if !Utilities.userMemberOfTeam(user: user, team: team) {
                        this.allJoinableTeams?.append(team)
                    }
                }
            }
            
            this.joinTeamsProgressIndicator.stopAnimation(nil)
            this.performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "ShowJoinTeamsSegue"), sender: self)
        }
    }
    
    @IBAction func logoutBtnPressed(_ sender: Any) {
        Logger.log("logoutBtnPressed")
        let status = FirebaseUtilities.logoutCurrentUser()
        if !status.status {
            let _ = self.displayAlert(title: "Logout Error", message: "An error occured when attempting to sign out: \(status.message)")
        }
        
        // TODO: Send message that a logout occured.
    }
    
    @IBAction func deleteAccountBtnPressed(_ sender: Any) {
        Logger.log("deleteAccountBtnPressed")
        let _ = self.displayAlert(title: "Unsupported Functionality", message: "This functionality is currently not supported or implemented.")
    }
    
    @IBAction func accountSupportBtnPressed(_ sender: Any) {
        Logger.log("accountSupportBtnPressed")
        let emailService = NSSharingService.init(named: NSSharingService.Name.composeEmail)!
        emailService.recipients = ["delegation.application@gmail.com"]
        emailService.subject = "Delegation Application Support"
        
        if emailService.canPerform(withItems: []) {
            emailService.perform(withItems: [])
        } else {
            let _ = self.displayAlert(title: "Unable to Create Email", message: "The default mail application cannot be opened. Please send a message to delegation.application@gmail.com with your issue.")
        }

    }
    
    func displayAlert(title: String, message: String) -> Bool {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        return alert.runModal() == .alertFirstButtonReturn
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier?.rawValue == "ShowYourTeamsSegue" {
            if let dest = segue.destinationController as? YourTeamViewController {
                Logger.log("ShowYourTeamsSegue called")
                dest.user = self.user
                dest.teams = self.user?.getTeams()
            }
        }
        
        if segue.identifier?.rawValue == "ShowJoinTeamsSegue" {
            if let dest = segue.destinationController as? JoinTeamViewController {
                Logger.log("ShowJoinTeamsSegue called")
                dest.user = self.user
                dest.teams = self.allJoinableTeams
            }
        }
    }
    
}
