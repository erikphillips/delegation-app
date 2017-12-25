//
//  WelcomeViewController.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/10/17.
//  Copyright © 2017 Erik Phillips. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {

    private var segueUser: User?
    private var uid: String = ""

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
            
            Auth.auth().signIn(withEmail: username!, password: password!) {
                [weak self] (user, error) in
                guard let this = self else { return }
                
                if let user = user {
                    this.uid = user.uid
                    print("Received UID: \(this.uid)")
                    
                    let ref: DatabaseReference! = Database.database().reference()
                    ref.child("users/\(this.uid)/information").observeSingleEvent(of: .value, with: { (snapshot) in
                        guard let this = self else { return }
                        
                        let value = snapshot.value as? NSDictionary
                        let firstname = value?["firstname"] as? String ?? ""
                        let lastname = value?["lastname"] as? String ?? ""
                        let email = value?["email"] as? String ?? ""
                        let phone = value?["phone"] as? String ?? ""
                        
                        this.segueUser = User(uid: this.uid, firstname: firstname, lastname: lastname, email: email, phone: phone)
//                        this.segueUser = User(uid: this.uid, snapshot: snapshot)
                        this.performSegue(withIdentifier: "SubmitLogin", sender: nil)
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    this.displayAlert(title: "Signin Error", message: "\(error.localizedDescription) Please try the signin process again or create a new account.")
                } else {
                    print("Unknown signin error")
                    this.displayAlert(title: "Signin Error", message: "An unknown error occured when signing into to the account. Please try the signin process again or create a new account.")
                }
            }
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
    
    @IBAction func demoActionAdminLogin(_ sender: Any) {
        usernameTextField.text = "admin@delegation.com"
        passwordTextField.text = "password"
    }
    
    @IBAction func demoActionUserLogin(_ sender: Any) {
        usernameTextField.text = "user1@delegation.com"
        passwordTextField.text = "password"
    }
    
    @IBAction func unwindToWelcomeView(segue: UIStoryboardSegue) { }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SubmitLogin" {
            print("Preparing SubmitLogin segue...")
            if let dest = segue.destination as? MainTabBarViewController {
                dest.user = self.segueUser
            }
        }
    }

}
