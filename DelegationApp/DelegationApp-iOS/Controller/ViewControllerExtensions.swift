//
//  ViewControllerUtilities.swift
//  DelegationApp
//
//  Created by Erik Phillips on 12/11/17.
//  Copyright © 2017-2018 Erik Phillips. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func signoutUser() {
        let firebaseAuth = Auth.auth()
        do {
            Logger.log("attempting to sign out current user...")
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            Logger.log("Error signing out: \(signOutError)", event: .error)
        }
    }
    
//    func displayAlert(title: String, message: String) {
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        
//        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
    //            Logger.log("You've pressed OK button");
//        }
//        
//        alertController.addAction(OKAction)
//        self.present(alertController, animated: true, completion:nil)
//    }
}


