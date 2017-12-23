//
//  TeamPromptViewController.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/16/17.
//  Copyright © 2017 Erik Phillips. All rights reserved.
//

import UIKit
import Firebase

class TeamPromptViewController: UIViewController {

    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToCreateAccountView", sender: nil)
    }
    
    @IBAction func joinExistingTeamPressed(_ sender: Any) {
        let ref: DatabaseReference! = Database.database().reference()
        ref.child("teams").observeSingleEvent(of: .value, with: {
            [weak self] (snapshot) in
            guard let this = self else { return }
            
            let value = snapshot.value as? NSDictionary
            print(value)
        }) { (error) in
            print(error.localizedDescription)
        }
        
        self.performSegue(withIdentifier: "CreateAccountJoinTeam", sender: nil)
    }
    
    @IBAction func createNewTeamPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "CreateAccountCreateTeam", sender: nil)
    }
    
    @IBAction func unwindToTeamPromptView(segue: UIStoryboardSegue) { }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateAccountJoinTeam" {
            print("Preparing CreateAccountJoinTeam segue...")
            if let dest = segue.destination as? JoinTeamViewController {
                dest.user = self.user
            }
        } else if segue.identifier == "CreateAccountCreateTeam" {
            print("Preparing CreateAccountCreateTeam segue...")
            if let dest = segue.destination as? CreateTeamViewController {
                dest.user = self.user
            }
        }
    }

}
