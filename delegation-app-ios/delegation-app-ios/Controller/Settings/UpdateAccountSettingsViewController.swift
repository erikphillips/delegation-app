//
//  UpdateAccountSettingsViewController.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/25/17.
//  Copyright © 2017 Erik Phillips. All rights reserved.
//

import UIKit

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
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if  firstNameTextField.text != user?.getFirstName() ||
            lastNameTextField.text != user?.getLastName() ||
            emailAddressTextField.text != user?.getEmailAddress() ||
            phoneNumberTextField.text != user?.getPhoneNumber() {
            
            
        }
        
        if let (status, resp) = self.user?.updateUserInDatabase() { // perform the update action
            
            if status == 200 { self.updateUserInformation = true }
            if status == 404 { self.updateUserInformation = false }
            
            let alertController = UIAlertController(title: "Update User", message: resp, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) {
                [weak self] (action:UIAlertAction) in
                guard let this = self else { return }
                
                this.performSegue(withIdentifier: "unwindToSettingsTableView", sender: nil)
            }
            
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
        } else {
            self.updateUserInformation = false
            
            let alertController = UIAlertController(title: "Update User", message: "Failed to update user due to an unknown error.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) {
                [weak self] (action:UIAlertAction) in
                guard let this = self else { return }
                
                this.performSegue(withIdentifier: "unwindToSettingsTableView", sender: nil)
            }
            
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.updateUserInformation = false
        self.performSegue(withIdentifier: "unwindToSettingsTableView", sender: nil)
    }
    
//    func displayAlert(title: String, message: String, positiveAction: Any?) {
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//
//        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
//            print("You've pressed OK button")
//        }
//
//        alertController.addAction(OKAction)
//        self.present(alertController, animated: true, completion:nil)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToSettingsTableView" {
            if let dest = segue.destination as? SettingsTableViewController {
                if self.updateUserInformation {
                    dest.user = self.user
                }
            }
        }
    }

}
