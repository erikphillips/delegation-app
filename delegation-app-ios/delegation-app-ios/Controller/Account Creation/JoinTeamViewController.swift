//
//  JoinTeamViewController.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/16/17.
//  Copyright © 2017 Erik Phillips. All rights reserved.
//

import UIKit
import Firebase

class JoinTeamViewController: UIViewController {

    var user: User?
    
    @IBOutlet weak var uiViewOutlet: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToTeamPromptView", sender: nil)
    }
    
    @IBAction func createNewAccountAndJoinTeam(_ sender: Any) {
        if let user = self.user {
            Auth.auth().createUser(withEmail: user.getEmailAddress(), password: user.getPassword()) {
                [weak self](user, error) in
                guard let this = self else { return }
                
                if (user != nil && error == nil) {
                    print("firebase: user added successfully")
                    
                    let uid = Auth.auth().currentUser!.uid
                    print("Got UID: \(uid)")
                    
                    let ref = Database.database().reference(withPath: "users/\(uid)")
                    
                    ref.child("firstname").setValue(this.user?.getFirstName())
                    ref.child("lastname").setValue(this.user?.getLastName())
                    ref.child("email").setValue(this.user?.getEmailAddress())
                    ref.child("phone").setValue(this.user?.getPhoneNumber())
                    
                } else {
                    print("firebase: failed to add user")
                }
            }
        } else {
            print("createNewAccountAndJoinTeam failed - unable to unwrap user")
        }
        
        self.performSegue(withIdentifier: "unwindToWelcomeFromJoinTeam", sender: nil)
    }
    
    @IBAction func unwindToJoinTeamView(segue: UIStoryboardSegue) { }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmbeddedSegue" {
            print("Preparing EmbeddedSegue segue...")
            if let dest = segue.destination as? JoinTeamTableViewController {
                dest.user = self.user
            }
        }
    }

}
