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
    var selectedTeams: [String]?
    var teamsArray: [Team]?
    
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var uiViewOutlet: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("JoinTeam Loaded...")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("JoinTeam Will Appear...")
        print("selectedTeams length: \(self.selectedTeams?.count)")
        
        if let selectedTeams = self.selectedTeams {
            if selectedTeams.count <= 0 {
                createAccountButton.setTitle("Create Account", for: .normal)
            } else if selectedTeams.count == 1 {
                createAccountButton.setTitle("Create Account and Join 1 Team", for: .normal)
            } else {
                createAccountButton.setTitle("Create Account and Join \(selectedTeams.count) Teams", for: .normal)
            }
        } else {
            createAccountButton.setTitle("Create Account", for: .normal)
        }
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
                    let uid = Auth.auth().currentUser!.uid
                    print("Got UID: \(uid)")
                    
                    let ref = Database.database().reference(withPath: "users/\(uid)")
                    
                    ref.child("firstname").setValue(this.user?.getFirstName())
                    ref.child("lastname").setValue(this.user?.getLastName())
                    ref.child("email").setValue(this.user?.getEmailAddress())
                    ref.child("phone").setValue(this.user?.getPhoneNumber())
                    
                    for id in (this.selectedTeams ?? []) {
                        ref.child("teams").childByAutoId().setValue(id)
                    }
                    
                    print("firebase: user added successfully")
                    
                    this.performSegue(withIdentifier: "unwindToWelcomeFromJoinTeam", sender: nil)
                } else {
                    print("firebase: failed to add user")
                    print(error?.localizedDescription)
                }
            } 
        } else {
            print("createNewAccountAndJoinTeam failed - unable to unwrap user")
        }
        
        
    }
    
    @IBAction func unwindToJoinTeamView(segue: UIStoryboardSegue) { }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTeamSelection" {
            print("Preparing ShowTeamSelection segue...")
            if let dest = segue.destination as? JoinTeamTableViewController {
                dest.user = self.user
                dest.selectedTeams = self.selectedTeams
                dest.teamsArray = self.teamsArray
            }
        }
    }

}
