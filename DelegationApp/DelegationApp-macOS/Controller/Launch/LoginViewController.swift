//
//  LoginViewController.swift
//  DelegationApp-macOS
//
//  Created by Erik Phillips on 3/7/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import Cocoa

class LoginViewController: NSViewController {

    @IBOutlet weak var emailAddressTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSSecureTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        Logger.log("LoginViewController viewDidLoad")
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        Logger.log("loginButtonPressed")
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        Logger.log("cancelButtonPressed")
        self.dismissViewController(self)
    }
    
}
