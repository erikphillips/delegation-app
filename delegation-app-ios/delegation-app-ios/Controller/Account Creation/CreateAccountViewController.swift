//
//  CreateAccountViewController.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/11/17.
//  Copyright © 2017 Erik Phillips. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    private var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(CreateAccountViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(CreateAccountViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        if let firstname = firstnameTextField.text {
            if let lastname = lastnameTextField.text {
                if let email = emailAddressTextField.text {
                    if let password = passwordTextField.text {
                        if let confirmPassword = confirmPasswordTextField.text {
                            if password == confirmPassword {
                                self.user = User(firstname: firstname, lastname: lastname, email: email, phone: "")
                                self.performSegue(withIdentifier: "CreateAccountContinue", sender: nil)
                            } else {
                                self.displayAlert(title: "Incorrect Passwords",
                                                  message: "The passwords do not match. Please confirm passwords.")
                            }
                        } else {
                            self.displayAlert(title: "Confirm Password Required", message: "A confirmation password is required.")
                        }
                    } else {
                        self.displayAlert(title: "Password Required", message: "A password is required.")
                    }
                } else {
                    self.displayAlert(title: "Email Required", message: "An email address is required.")
                }
            } else {
                self.displayAlert(title: "Lastname Required", message: "A lastname is required.")
            }
        } else {
            self.displayAlert(title: "Firstname Required", message: "A firstname is required.")
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToWelcomeView", sender: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            print("You've pressed OK button");
        }
        
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    @IBAction func unwindToCreateAccountView(segue: UIStoryboardSegue) { }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateAccountContinue" {
            print("Preparing CreateAccountContinue segue...")
            if let dest = segue.destination as? TeamPromptViewController {
                dest.user = self.user
            }
        }
    }
}
