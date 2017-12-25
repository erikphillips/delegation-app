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
        self.updateUserInformation = true
        self.performSegue(withIdentifier: "unwindToSettingsTableView", sender: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.updateUserInformation = false
        self.performSegue(withIdentifier: "unwindToSettingsTableView", sender: nil)
    }
    
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
