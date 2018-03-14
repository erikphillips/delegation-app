//
//  ViewController.swift
//  macOSDelegationApp
//
//  Created by Erik Phillips on 3/5/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import Cocoa

class LaunchViewController: NSViewController {
    
    var user: User?

    @IBOutlet weak var emailAddressTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSSecureTextField!
    @IBOutlet weak var loginProgressIndicator: NSProgressIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Logger.log("LaunchViewController viewDidLoad")
        
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
//    @IBAction func demoLoadAdminBtnPressed(_ sender: Any) {
//        Logger.log("demoLoadAdminBtnPressed")
//        self.emailAddressTextField.stringValue = "admin@delegation.com"
//        self.passwordTextField.stringValue = "password"
//    }
    
    @IBOutlet weak var demoSavedCredentials: NSPopUpButton!
    @IBAction func demoLoadSavedCredentials(_ sender: Any) {
        
        let email = self.demoSavedCredentials.selectedItem!.title
        self.emailAddressTextField.stringValue = email
        
        switch email {
        case "admin@delegation.com":
            self.passwordTextField.stringValue = "password"
            break
        case "user1@delegation.com":
            self.passwordTextField.stringValue = "password"
            break
        case "user3@delgation.com":
            self.passwordTextField.stringValue = "password"
            break
        default:
            break
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        Logger.log("loginButtonPressed, show main segue called")
        
        let username = self.emailAddressTextField.stringValue
        let password = self.passwordTextField.stringValue
        
        self.loginProgressIndicator.startAnimation(nil)
        FirebaseUtilities.performWelcomeProcedure(username: username, password: password, callback: {
            [weak self] (user, tasks, status) in
            guard let this = self else { return }
            
            if let user = user {
                this.user = user
                this.user?.setupCallback = {
                    [weak this] in
                    guard let that = this else { return }
                    that.loginProgressIndicator.stopAnimation(nil)
                    that.performSegue(withIdentifier: NSStoryboardSegue.Identifier("ShowMainViewSegue"), sender: nil)
                    that.view.window?.close()
                }
            } else {
                Logger.log("loginButtonPressed error: unable to retrieve a valid user", event: .error)
                if status.status == false {
                    this.loginProgressIndicator.stopAnimation(nil)
                    let _ = this.displayAlert(title: "Unable to Login", message: "Unable to login with provided username and password \(status.message)")
                }
            }
        })
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
        if segue.identifier?.rawValue == "CreateNewAccountSegue" {
            if let dest = segue.destinationController as? CreateAccountViewController {
                Logger.log("CreateNewAccountSegue called")
                dest.loginDictionary = ["email": self.emailAddressTextField.stringValue,
                                        "password": self.passwordTextField.stringValue]
            }
        }
        
        if segue.identifier?.rawValue == "ShowMainViewSegue" {
            if let dest = segue.destinationController as? MainWindowController {
                Logger.log("ShowMainViewSegue called")
                dest.user = self.user
            }
        }
    }

}

