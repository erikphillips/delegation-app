//
//  CreateAccountViewController.swift
//  DelegationApp-macOS
//
//  Created by Erik Phillips on 3/7/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import Cocoa

class CreateAccountViewController: NSViewController {

    var loginDictionary: NSDictionary?
    
    @IBOutlet weak var firstNameTextField: NSTextField!
    @IBOutlet weak var lastNameTextField: NSTextField!
    @IBOutlet weak var emailAddressTextField: NSTextField!
    @IBOutlet weak var phoneNumberTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSSecureTextField!
    @IBOutlet weak var confirmPasswordTextField: NSSecureTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.log("CreateAccountViewController viewDidLoad")
        
        if let dict = self.loginDictionary {
            self.emailAddressTextField.stringValue = dict.value(forKey: "email") as? String ?? Globals.UserGlobals.DEFAULT_EMAIL
            self.passwordTextField.stringValue = dict.value(forKey: "password") as? String ?? Globals.UserGlobals.DEFAULT_PASSWORD
        }
    }
    
    @IBAction func createAccountButtonPressed(_ sender: Any) {
        Logger.log("createAccountButtonPressed")
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        Logger.log("cancelButtonPressed")
        self.dismissViewController(self)
    }
}
