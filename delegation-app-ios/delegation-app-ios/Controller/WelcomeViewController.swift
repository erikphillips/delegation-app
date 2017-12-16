//
//  WelcomeViewController.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/10/17.
//  Copyright © 2017 Erik Phillips. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

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
        }
        
        self.performSegue(withIdentifier: "SubmitLogin", sender: nil)
    }
    
    
    @IBAction func unwindToWelcomeView(segue: UIStoryboardSegue) { }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SubmitLogin" {
            print("Preparing SubmitLogin segue...")
        }
    }

}
