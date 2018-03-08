//
//  LoginViewController.swift
//  DelegationApp-macOS
//
//  Created by Erik Phillips on 3/7/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import Cocoa

class LoginViewController: NSViewController {

    var parentView: NSViewController?
    
    @IBOutlet weak var emailAddressTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSSecureTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        Logger.log("LoginViewController viewDidLoad")
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        Logger.log("loginButtonPressed")
//        self.dismissViewController(self)
        self.performSegue(withIdentifier: NSStoryboardSegue.Identifier(rawValue: "ShowMainViewSegue"), sender: nil)
        self.view.window?.close()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        Logger.log("cancelButtonPressed")
        self.dismissViewController(self)
    }
    
//    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
//        if segue.identifier?.rawValue == "ShowMainViewSegue" {
//            Logger.log("ShowMainViewSegue called")
//
//            if let parent = self.parentView as? LaunchViewController {
//                parent.loggedIn = true
//                self.dismissViewController(self)
//
//            }
//        }
//    }
    
}
