//
//  TeamPromptViewController.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/16/17.
//  Copyright © 2017-2018 Erik Phillips. All rights reserved.
//

import UIKit
import Firebase

class TeamPromptViewController: UIViewController {

    var user: User?
    var teams: [Team]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToCreateAccountView", sender: nil)
    }
    
    // TODO: This needs to be tested
    @IBAction func joinExistingTeamPressed(_ sender: Any) {
        FirebaseUtilities.getAllTeams(callback: {
            [weak self] (teams, error) in
            guard let this = self else { return }
            
            if let teams = teams {
                this.teams = teams
                this.performSegue(withIdentifier: "CreateAccountJoinTeam", sender: nil)
            } else if let error = error {
                this.displayAlert(title: "Error", message: "Unable to load team information at this time. \(error.localizedDescription)")
            } else {
                this.displayAlert(title: "Unknown Error", message: "An unknown error occurred and the teams cannot be loaded at this time.")
            }
        })
    }
    
    @IBAction func createNewTeamPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "CreateAccountCreateTeam", sender: nil)
    }
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            print("You've pressed OK button");
        }
        
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    @IBAction func unwindToTeamPromptView(segue: UIStoryboardSegue) { }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateAccountJoinTeam" {
            print("Preparing CreateAccountJoinTeam segue...")
            if let dest = segue.destination as? JoinTeamViewController {
                dest.user = self.user
                dest.selectedTeams = []
                dest.teamsArray = self.teams
            }
        } else if segue.identifier == "CreateAccountCreateTeam" {
            print("Preparing CreateAccountCreateTeam segue...")
            if let dest = segue.destination as? CreateTeamViewController {
                dest.user = self.user
            }
        }
    }

}
