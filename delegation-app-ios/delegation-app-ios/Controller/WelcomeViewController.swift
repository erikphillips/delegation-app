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
                    ref.child("users/\(this.uid)").observeSingleEvent(of: .value, with: { (snapshot) in
                        guard let this = self else { return }
                        
//                        let value = snapshot.value as? NSDictionary
//                        let firstname = value?["firstname"] as? String ?? ""
//                        let lastname = value?["lastname"] as? String ?? ""
//                        let email = value?["email"] as? String ?? ""
//                        let phone = value?["phone"] as? String ?? ""
                        
//                        this.segueUser = User(firstname: firstname, lastname: lastname, email: email, phone: phone)
                        this.segueUser = User(uid: this.uid, snapshot: snapshot)
                        this.performSegue(withIdentifier: "SubmitLogin", sender: nil)
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                }
            }
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SubmitLogin" {
            print("Preparing SubmitLogin segue...")
            print(segue.destination)
            if let dest = segue.destination as? MainTabBarViewController {
                dest.user = self.segueUser
            }
        }
    }

}
