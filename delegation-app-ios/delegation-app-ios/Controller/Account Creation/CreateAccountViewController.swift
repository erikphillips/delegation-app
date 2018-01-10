//
//  CreateAccountViewController.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/11/17.
//  Copyright © 2017-2018 Erik Phillips. All rights reserved.
//

import UIKit
import Firebase

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
    
    @IBAction func loadFakeDataButtonPressed(_ sender: Any) {
        self.firstnameTextField.text = "Erik"
        self.lastnameTextField.text = "Phillips"
        self.emailAddressTextField.text = "erik@app.com"
        self.passwordTextField.text = "123456"
        self.confirmPasswordTextField.text = "123456"
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        let firstname = firstnameTextField.text!
        let lastname = lastnameTextField.text!
        let email = emailAddressTextField.text!
        let password = passwordTextField.text!
        let confirmPassword = confirmPasswordTextField.text!
        
        if firstname == "" {
            self.displayAlert(title: "Firstname Required", message: "A firstname is required.")
            return
        }
        
        if lastname == "" {
            self.displayAlert(title: "Lastname Required", message: "A lastname is required.")
            return
        }
        
        
        let emailStatus = Utilities.validateEmail(email)
        if !emailStatus.status {
            self.displayAlert(title: "Email Required", message: "The email address provided is not valid. \(emailStatus.message)")
            return
        }
        
        let passwordStatus = Utilities.validatePasswords(pswd: password, cnfrm: confirmPassword)
        if !passwordStatus.status {
            self.displayAlert(title: "Password Required", message: "\(passwordStatus.message)")
            return
        }
        
        // If the validation passes, create a user object and perform the segue
        self.user = User(uid: "", firstname: firstname, lastname: lastname, email: email, phone: "", password: password)
        self.performSegue(withIdentifier: "CreateAccountContinue", sender: nil)
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
