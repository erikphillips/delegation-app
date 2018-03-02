//
//  CreateAccountViewController.swift
//  DelegationApp
//
//  Created by Erik Phillips on 12/11/17.
//  Copyright © 2017-2018 Erik Phillips. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountInitialViewController: UIViewController, UITextFieldDelegate {
    
    var passedUsername: String?
    var passedPassword: String?

    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    private var userDictionary: [String: String]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.firstnameTextField.delegate = self
        self.lastnameTextField.delegate = self
        self.emailAddressTextField.delegate = self
        self.passwordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self
        
        if let passedUsername = self.passedUsername {
            self.emailAddressTextField.text = passedUsername
        }
        
        if let passedPassword = self.passedPassword {
            self.passwordTextField.text = passedPassword
        }
        
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loadFakeDataButtonPressed(_ sender: Any) {
        self.firstnameTextField.text = "Erik"
        self.lastnameTextField.text = "Phillips"
        self.emailAddressTextField.text = "erik@app.com"
        self.phoneNumberTextField.text = "9703196538"
        self.passwordTextField.text = "123456"
        self.confirmPasswordTextField.text = "123456"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstnameTextField:
            textField.resignFirstResponder()
            lastnameTextField.becomeFirstResponder()
            break
        case lastnameTextField:
            textField.resignFirstResponder()
            emailAddressTextField.becomeFirstResponder()
            break
        case emailAddressTextField:
            textField.resignFirstResponder()
            phoneNumberTextField.becomeFirstResponder()
            break
        case phoneNumberTextField:
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
            break
        case passwordTextField:
            textField.resignFirstResponder()
            confirmPasswordTextField.becomeFirstResponder()
            break
        case confirmPasswordTextField:
            textField.resignFirstResponder()
            self.continueButtonPressed(self)
            break
        default:
            textField.resignFirstResponder()
            break
        }
        
        return false
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        let firstname = firstnameTextField.text!
        let lastname = lastnameTextField.text!
        let email = emailAddressTextField.text!
        let phone = phoneNumberTextField.text!
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
        
        let phoneStatus = Utilities.validatePhoneNumber(phone)
        if !phoneStatus.status {
            self.displayAlert(title: "Phone Number Required", message: "The phone number provided is not valid. \(phoneStatus.message)")
            return
        }
        
        let passwordStatus = Utilities.validatePasswords(pswd: password, cnfrm: confirmPassword)
        if !passwordStatus.status {
            self.displayAlert(title: "Password Required", message: "\(passwordStatus.message)")
            return
        }
        
        self.displayLoadingScreen()
        FirebaseUtilities.emailAddressInUse(email: email, callback: {
            [weak self] (status) in
            guard let this = self else { return; }
            
            this.dismissLoadingScreen {
                if status.status {
                    // If the validation passes, create a user dictionary and perform the segue
                    this.userDictionary = [
                        "firstname": firstname,
                        "lastname": lastname,
                        "phone": phone,
                        "email": email,
                        "password": password ]
                    this.performSegue(withIdentifier: "CreateAccountContinue", sender: nil)
                } else {
                    this.displayAlert(title: "Email Address Invalid", message: status.message)
                }
            }
        })
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
            Logger.log("You've pressed OK button");
        }
        
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    func displayLoadingScreen() {
        Logger.log("displaying loading screen...")
        
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        self.present(alert, animated: true, completion: nil)
    }
    
    func dismissLoadingScreen(callback: @escaping (() -> Void)) {
        Logger.log("dismissing loading screen...")
        self.dismiss(animated: true, completion: {
            callback()
        })
    }
    
    @IBAction func unwindToCreateAccountView(segue: UIStoryboardSegue) { }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateAccountContinue" {
            Logger.log("Preparing CreateAccountContinue segue...")
            if let dest = segue.destination as? CreateAccountTeamPromptViewController {
                dest.userDictionary = self.userDictionary
            }
        }
    }
}
