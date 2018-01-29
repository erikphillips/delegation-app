//
//  UpdateAccountSettingsViewController.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/25/17.
//  Copyright © 2017-2018 Erik Phillips. All rights reserved.
//

import UIKit
import Firebase

class UpdateAccountSettingsViewController: UIViewController {

    var user: User?
    
    private var updateUserInformation = false
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let user = user {
            self.firstNameTextField.text = user.getFirstName()
            self.lastNameTextField.text = user.getLastName()
            self.emailAddressTextField.text = user.getEmailAddress()
            self.phoneNumberTextField.text = user.getPhoneNumber()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
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
        self.updateUserInformation = false
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToSettingsTableView" {
            if let dest = segue.destination as? SettingsTableViewController {
                if self.updateUserInformation {
                    Logger.log("segue called - username=\"\(self.user?.getEmailAddress())\"")
                    dest.user = self.user
                }
            }
        }
    }

}
