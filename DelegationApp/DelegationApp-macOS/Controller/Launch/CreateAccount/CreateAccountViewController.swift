//
//  CreateAccountViewController.swift
//  DelegationApp-macOS
//
//  Created by Erik Phillips on 3/7/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import Cocoa

class CreateAccountViewController: NSViewController {

    @IBOutlet weak var firstNameTextField: NSTextField!
    @IBOutlet weak var lastNameTextField: NSTextField!
    @IBOutlet weak var emailAddressTextField: NSTextField!
    @IBOutlet weak var phoneNumberTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSSecureTextField!
    @IBOutlet weak var confirmPasswordTextField: NSSecureTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.log("CreateAccountViewController viewDidLoad")
    }
    
    @IBAction func createAccountButtonPressed(_ sender: Any) {
        Logger.log("createAccountButtonPressed")
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        Logger.log("cancelButtonPressed")
        self.dismissViewController(self)
    }
}
