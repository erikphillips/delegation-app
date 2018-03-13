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

    @IBOutlet weak var firstnameTextField: NSTextField!
    @IBOutlet weak var lastnameTextField: NSTextField!
    @IBOutlet weak var emailTextField: NSTextField!
    @IBOutlet weak var phoneTextField: NSTextField!
    @IBOutlet weak var versionString: NSTextField!
    
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
    }
    
    @IBAction func logoutBtnPressed(_ sender: Any) {
        Logger.log("logoutBtnPressed")
    }
    
    @IBAction func deleteAccountBtnPressed(_ sender: Any) {
        Logger.log("deleteAccountBtnPressed")
    }
    
    @IBAction func accountSupportBtnPressed(_ sender: Any) {
        Logger.log("accountSupportBtnPressed")
    }
    
}
