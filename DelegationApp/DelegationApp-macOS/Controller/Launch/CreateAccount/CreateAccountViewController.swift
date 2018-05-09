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
    
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    @IBOutlet weak var createAccountButton: NSButton!
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
        
        let firstname = Utilities.trimWhitespace(self.firstNameTextField.stringValue)
        let lastname = Utilities.trimWhitespace(self.lastNameTextField.stringValue)
        let email = Utilities.trimWhitespace(self.emailAddressTextField.stringValue)
        let phone = Utilities.unformat(phoneNumber: self.phoneNumberTextField.stringValue)
        let password = self.passwordTextField.stringValue
        let confirmPassword = self.confirmPasswordTextField.stringValue
        
        if firstname == "" {
            _ = self.displayAlert(title: "Firstname Required", message: "A firstname is required.")
            return
        }
        
        if lastname == "" {
            _ = self.displayAlert(title: "Lastname Required", message: "A lastname is required.")
            return
        }
        
        let emailStatus = Utilities.validateEmail(email)
        if !emailStatus.status {
            _ = self.displayAlert(title: "Email Required", message: "The email address provided is not valid. \(emailStatus.message)")
            return
        }
        
        let phoneStatus = Utilities.validatePhoneNumber(phone)
        if !phoneStatus.status {
            _ = self.displayAlert(title: "Phone Number Required", message: "The phone number provided is not valid. \(phoneStatus.message)")
            return
        }
        
        let passwordStatus = Utilities.validatePasswords(pswd: password, cnfrm: confirmPassword)
        if !passwordStatus.status {
            _ = self.displayAlert(title: "Password Required", message: "\(passwordStatus.message)")
            return
        }
        
        self.progressIndicator.startAnimation(nil)
        self.createAccountButton.isEnabled = false
        FirebaseUtilities.emailAddressInUse(email: email, callback: {
            [firstname, lastname, email, phone, password, weak self] (status) in
            guard let this = self else { return }
            
            if status.status {
                FirebaseUtilities.createNewUser(email: email, password: password, callback: {
                    [firstname, lastname, email, phone, weak this] (uuid, status) in
                    guard let that = this else { return }
                    
                    that.progressIndicator.stopAnimation(nil)
                    that.createAccountButton.isEnabled = true
                    
                    if status.status {
                        Logger.log("new user created: \(uuid)")
                        _ = User(uuid: uuid, firstname: firstname, lastname: lastname, phoneNumber: phone, emailAddress: email)
                        that.dismissViewController(that)
                    } else {
                        Logger.log("error creating a new user in firebase - \(status.message)", event: .error)
                        _ = that.displayAlert(title: "Error Creating Account", message: status.message)
                    }
                })
            } else {
                this.progressIndicator.stopAnimation(nil)
                this.createAccountButton.isEnabled = true
                _ = this.displayAlert(title: "Email Address Invalid", message: status.message)
            }
        })
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        Logger.log("cancelButtonPressed")
        self.dismissViewController(self)
    }
    
    func displayAlert(title: String, message: String) -> Bool {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        return alert.runModal() == .alertFirstButtonReturn
    }
}
