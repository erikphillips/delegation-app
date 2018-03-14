//
//  UpdateAccountSettingsViewController.swift
//  DelegationApp
//
//  Created by Erik Phillips on 12/25/17.
//  Copyright © 2017-2018 Erik Phillips. All rights reserved.
//

import UIKit
import Firebase

class UpdateAccountSettingsViewController: UIViewController, UITextFieldDelegate {

    var user: User?
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.emailAddressTextField.delegate = self
        self.phoneNumberTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self
        
        if let user = user {
            self.firstNameTextField.text = user.getFirstName()
            self.lastNameTextField.text = user.getLastName()
            self.emailAddressTextField.text = user.getEmailAddress()
            self.phoneNumberTextField.text = user.getPhoneNumber()
            
            user.observers.observe(canary: self, callback: { (user: User) in
                self.firstNameTextField.text = user.getFirstName()
                self.lastNameTextField.text = user.getLastName()
                self.emailAddressTextField.text = user.getEmailAddress()
                self.phoneNumberTextField.text = user.getPhoneNumber()
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstNameTextField:
            textField.resignFirstResponder()
            self.lastNameTextField.becomeFirstResponder()
            break
        case lastNameTextField:
            textField.resignFirstResponder()
            self.emailAddressTextField.becomeFirstResponder()
            break
        case emailAddressTextField:
            textField.resignFirstResponder()
            self.phoneNumberTextField.becomeFirstResponder()
            break
        case phoneNumberTextField:
            textField.resignFirstResponder()
            self.passwordTextField.becomeFirstResponder()
            break
        case passwordTextField:
            textField.resignFirstResponder()
            self.confirmPasswordTextField.becomeFirstResponder()
            break
        case confirmPasswordTextField:
            textField.resignFirstResponder()
            self.saveButtonPressed(self)
            break
        default:
            textField.resignFirstResponder()
            break
        }
        
        return false
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        var newFirstName: String? = nil
        var newLastName: String? = nil
        var newPhoneNumber: String? = nil
        var newEmailAddress: String? = nil
        var newPassword: String? = nil
        var newConfirmPassword: String? = nil
        
        if self.firstNameTextField.text != self.user?.getFirstName() {
            newFirstName = self.firstNameTextField.text
        }
        
        if self.lastNameTextField.text != self.user?.getLastName() {
            newLastName = self.lastNameTextField.text
        }
        
        if self.phoneNumberTextField.text != self.user?.getPhoneNumber() {
            newPhoneNumber = self.phoneNumberTextField.text
        }
        
        if self.emailAddressTextField.text != self.user?.getEmailAddress() {
            newEmailAddress = self.emailAddressTextField.text
            
            let verifyStatus = Utilities.validateEmail(newEmailAddress ?? Globals.UserGlobals.DEFAULT_EMAIL)
            if !verifyStatus.status {
                newEmailAddress = nil
                Logger.log("invalid email address: \(verifyStatus.message)")
                // TODO: Display alert for invalid email address
            }
        }
        
        if self.passwordTextField.text != Globals.UserGlobals.DEFAULT_PASSWORD
            || self.confirmPasswordTextField.text != Globals.UserGlobals.DEFAULT_PASSWORD {
            
            newPassword = self.passwordTextField.text
            newConfirmPassword = self.confirmPasswordTextField.text
            
            let verifyStatus = Utilities.validatePasswords(pswd: newPassword ?? Globals.UserGlobals.DEFAULT_PASSWORD,
                                                           cnfrm: newConfirmPassword ?? Globals.UserGlobals.DEFAULT_PASSWORD)
            
            if !verifyStatus.status {
                newPassword = nil
                newConfirmPassword = nil
                Logger.log("invalid passwords: \(verifyStatus.message)")
                // TODO: Display alert indicating invalid passwords
            }
        }
        
        if let user = self.user {
            Logger.log("Updating the current user with new information from settings update.")
            user.updateCurrentUser(firstname: newFirstName, lastname: newLastName, email: newEmailAddress, phone: newPhoneNumber, password: newPassword)
            self.performSegue(withIdentifier: "unwindToSettingsTableView", sender: nil)
        }
        
        // TODO: Fix this to work with the new API
//        self.user?.setFirstName(self.firstNameTextField!.text!)
//        self.user?.setLastName(self.lastNameTextField!.text!)
//        self.user?.setPhoneNumber(self.phoneNumberTextField!.text!)
//
//        let dispatchGroup = DispatchGroup()
//
//        if self.emailAddressTextField.text != self.user?.getEmailAddress() {
//            dispatchGroup.enter()
//            FirebaseUtilities.updateCurrentUserEmailAddress(emailAddressTextField.text!, callback: {
//                [weak self] (status) in
//                guard let this = self else { return }
//
//                if status.status {
//                    Logger.log("Email address update msg: " + status.message)
//                    this.user?.setEmailAddress(this.emailAddressTextField.text!)
//                } else {
//                    Logger.log("Error: unable to update email address.", event: .error)
//                }
//
//                dispatchGroup.leave()
//            })
//        }
//
//        if self.passwordTextField.text! != "" {
//            Logger.log("Warning: will update password to '\(self.passwordTextField.text!)'", event: .warning)
//
//            dispatchGroup.enter()
//            FirebaseUtilities.updateCurrentUserPassword(self.passwordTextField.text!, callback: { (status) in
//                print("Password update msg: " + status.message)
//                dispatchGroup.leave()
//            })
//        } else {
//            Logger.log("Warning: will not update password", event: .warning)
//        }
//
//        dispatchGroup.notify(queue: .main) {
//            Logger.log("Both dispatch functions complete 👍")
//            if let (status, resp) = self.user?.updateUserInDatabase() {
//                if status == 200 { self.updateUserInformation = true }
//                if status == 404 { self.updateUserInformation = false }
//                Logger.log("User update: " + resp)
//                self.performSegue(withIdentifier: "unwindToSettingsTableView", sender: nil)
//            }
//        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToSettingsTableView", sender: nil)
    }
    
    func displayAlert(title: String, message: String, positiveAction: Any?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            Logger.log("You've pressed OK button")
        }

        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }

}
