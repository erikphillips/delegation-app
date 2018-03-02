//
//  WelcomeViewController.swift
//  DelegationApp
//
//  Created by Erik Phillips on 12/10/17.
//  Copyright © 2017-2018 Erik Phillips. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController, UITextFieldDelegate {

    private var segueUser: User?
    private var uuid: String = Globals.UserGlobals.DEFAULT_UUID
    
    private var seguePerformed = false

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Clear the password text field before the screen is presented
        Logger.log("WelcomeViewController will appear...")
        self.seguePerformed = false
        self.passwordTextField.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case usernameTextField:
            textField.resignFirstResponder()
            self.passwordTextField.becomeFirstResponder()
            break
        case passwordTextField:
            textField.resignFirstResponder()
            self.submitLogin(self)
            break
        default:
            textField.resignFirstResponder()
            break
        }
        
        return false
    }
    
    @IBAction func submitLogin(_ sender: Any) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        if username != "" && password != "" {
            Logger.log("starting the login process")
            
            self.displayLoadingScreen()
            FirebaseUtilities.performWelcomeProcedure(controller: self, username: username!, password: password!, callback: {
                [weak self] (user, tasks, status) in
                guard let this = self else { return }
                
                if let user = user {
                    this.segueUser = user
                    this.segueUser?.observers.observe(canary: this, callback: {
                        [weak this] (user) in
                        guard let that = this else { return }
                        
                        if that.seguePerformed == false {
                            that.seguePerformed = true
                            that.dismissLoadingScreen {
                                [weak that] in
                                guard let other = that else { return }
                                other.performSegue(withIdentifier: "SubmitLogin", sender: nil)
                            }
                        }
                    })
                    
                } else {
                    Logger.log("submitLogin error: unable to retrieve a valid user.", event: .error)
                    if status.status == false {
                        this.dismissLoadingScreen {
                            [weak this] in
                            guard let that = this else { return }
                            that.displayAlert(title: "Unable to Login", message: "Unable to login with provided username and password. \(status.message)")
                        }
                    }
                }
            })
        } else {
            if username == "" && password == "" {
                self.displayAlert(title: "Username and Password Required", message: "Both your username and password are required to signin. Please enter your information in the fields provided.")
            } else if username == "" {
                self.displayAlert(title: "Username Required", message: "A username is required. This is typically your email address. Please enter your username/email address in the field provided.")
            } else if password == "" {
                self.displayAlert(title: "Password Required", message: "Your password is required for login. Please enter your password in the field provided.")
            }
        }
    }
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            Logger.log("You've pressed OK button");
        }
        
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func displayLoadingScreen() {
        Logger.log("Displaying loading screen.")
        
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        alert.view.tintColor = Globals.UIGlobals.Colors.PRIMARY  // TODO: WHY DOES THIS NOT WORK?
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        self.present(alert, animated: true, completion: nil)
    }
    
    func dismissLoadingScreen(callback: @escaping (() -> Void)) {
        Logger.log("Dismissing loading screen...")
        self.dismiss(animated: true, completion: {
            callback()
        })
    }
    
    @IBAction func forgotButtonPressed(_ sender: Any) {
        let email = self.usernameTextField?.text ?? Globals.UserGlobals.DEFAULT_EMAIL
        if email != Globals.UserGlobals.DEFAULT_EMAIL {
            Auth.auth().sendPasswordReset(withEmail: email) {
                [weak self] (error) in
                guard let this = self else { return }
                if error == nil {
                    this.displayAlert(title: "Email Sent", message: "An email as been sent to your email address with instructions to reset your password.")
                } else {
                    this.displayAlert(title: "Error Sending Email", message: error?.localizedDescription ?? "Unknown Error")
                }
            }
        } else {
            self.displayAlert(title: "Enter Email Address", message: "Please enter your email address used with your Delegation Account. If you are unable to locate your email address, please email the support team at delegarion.application@gmail.com.")
        }
    }
    
    @IBAction func demoActionAdminLogin(_ sender: Any) {
        usernameTextField.text = "admin@delegation.com"
        passwordTextField.text = "password"
    }
    
    @IBAction func demoActionUserLogin(_ sender: Any) {
        usernameTextField.text = "user1@delegation.com"
        passwordTextField.text = "password"
    }
    
    @IBAction func unwindToWelcomeView(segue: UIStoryboardSegue) { }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SubmitLogin" {
            if let dest = segue.destination as? MainTabBarViewController {
                Logger.log("SubmitLogin segue called")
                dest.user = self.segueUser
            }
        }
        
        if segue.identifier == "WelcomeShowCreateAccount" {
            if let dest = segue.destination as? CreateAccountInitialViewController {
                Logger.log("WelcomeShowCreateAccount segue called")
                dest.passedUsername = self.usernameTextField.text
                dest.passedPassword = self.passwordTextField.text
            }
        }
    }

}
