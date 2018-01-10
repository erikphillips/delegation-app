//
//  WelcomeViewController.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/10/17.
//  Copyright © 2017-2018 Erik Phillips. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {

    private var segueUser: User?
    private var segueTasks: [Task]?
    private var uuid: String = ""

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Clear the password text field before the screen is presented
        passwordTextField.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func submitLogin(_ sender: Any) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        if username != "" && password != "" {
            print("Starting login process...")
            
//            self.displayLoadingScreen()
            FirebaseUtilities.performWelcomeProcedure(controller: self, username: username!, password: password!, callback: {
                [weak self] (user, tasks, error) in
                guard let this = self else { return }
                if let user = user {
                    this.segueUser = user
                    
                    if let tasks = tasks {
                        this.segueTasks = tasks
                    } else {
                        print("submitLogin warning: unable to find tasks for the current user.")
                    }
                    
                    this.performSegue(withIdentifier: "SubmitLogin", sender: nil)
                } else {
                    print("submitLogin error: unable to retrieve a valid user.")
                    if let error = error {
                        print(error.localizedDescription)
                        this.displayAlert(title: "Unable to Login", message: "Unable to login with provided username and password. \(error.localizedDescription)")
                    } else {
                        print("unknown error")
                        this.displayAlert(title: "Unable to Login", message: "Unable to login with provided username and password. Please verify your internet connection, username, and password.")
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
            print("You've pressed OK button");
        }
        
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    func displayLoadingScreen() {
        print("Displaying loading screen.")
        
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        self.present(alert, animated: true, completion: nil)
    }
    
    func dismissLoadingScreen() {
        print("Dismissing loading screen.")
        self.dismiss(animated: false, completion: nil)
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
            print("Preparing SubmitLogin segue...")
            if let dest = segue.destination as? MainTabBarViewController {
                dest.user = self.segueUser
            }
        }
    }

}
