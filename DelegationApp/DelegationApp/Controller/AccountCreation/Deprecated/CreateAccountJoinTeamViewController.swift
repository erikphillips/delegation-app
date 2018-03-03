//
//  JoinTeamViewController.swift
//  DelegationApp
//
//  Created by Erik Phillips on 12/16/17.
//  Copyright © 2017-2018 Erik Phillips. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountJoinTeamViewController: UIViewController {

    var userDictionary: [String: String]?
    var selectedTeams: [String]?
    var teamsArray: [Team]?
    
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var uiViewOutlet: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.log("JoinTeam Loaded...")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Logger.log("JoinTeam Will Appear...")
        Logger.log("selectedTeams length: \(self.selectedTeams?.count)")
        
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
        if let userDictionary = self.userDictionary {
            // TODO: Create a new user using the new API
            
//            FirebaseUtilities.createNewUser(newUser: user, selectedTeams: self.selectedTeams ?? [], callback: {
//                [weak self] (status) in
//                guard let this = self else { return }
//
//                if status.status {
//                    this.performSegue(withIdentifier: "unwindToWelcomeFromJoinTeam", sender: nil)
//                } else {
//                    Logger.log("ERROR: \(status.message)", event: .error)
//                }
//            })
        } else {
            Logger.log("createNewAccountAndJoinTeam failed - unable to unwrap user", event: .error)
        }
    }
    
    @IBAction func unwindToJoinTeamView(segue: UIStoryboardSegue) { }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTeamSelection" {
            Logger.log("Preparing ShowTeamSelection segue...")
//            if let dest = segue.destination as? JoinTeamTableViewController {
//                dest.userDictionary = self.userDictionary
//                dest.selectedTeams = self.selectedTeams
//                dest.teamsArray = self.teamsArray
//            }
        }
    }

}
