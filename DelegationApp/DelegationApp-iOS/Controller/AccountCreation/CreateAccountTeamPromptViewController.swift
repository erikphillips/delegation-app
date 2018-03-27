//
//  TeamPromptViewController.swift
//  DelegationApp
//
//  Created by Erik Phillips on 12/16/17.
//  Copyright © 2017-2018 Erik Phillips. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountTeamPromptViewController: UIViewController {

    var userDictionary: [String: String]?
    var teams: [Team]?
    
    @IBOutlet weak var joinTeamActivityIndicator: UIActivityIndicatorView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func createAccountPressed(_ sender: Any) {
        Logger.log("createAccountPressed")
        
        if let dict = self.userDictionary {
            FirebaseUtilities.createNewUser(email: dict["email"]!, password: dict["password"]!, callback: {
                [weak self] (uuid, status) in
                guard let this = self else { return }
                if status.status {
                    Logger.log("new user created: \(uuid)")
                    _ = User(uuid: uuid, firstname: dict["firstname"]!, lastname: dict["lastname"]!, phoneNumber: dict["phone"]!, emailAddress: dict["email"]!)
                    this.performSegue(withIdentifier: "unwindTeamPromptToWelcome", sender: nil)
                } else {
                    Logger.log("error creating a new user in firebase - \(status.message)", event: .error)
                    this.displayAlert(title: "Error Creating Account", message: status.message)
                }
            })
        } else {
            Logger.log("unable to unwrap user dictionary object", event: .error)
        }
    }
    
    @IBAction func joinExistingTeamButtonPressed(_ sender: Any) {
        self.joinTeamActivityIndicator.startAnimating()
        FirebaseUtilities.fetchAllTeams(callback: {
            [weak self] (teams) in
            guard let this = self else { return }
            this.joinTeamActivityIndicator.stopAnimating()
            this.teams = teams
            this.performSegue(withIdentifier: "CreatePromptToJoinTeamSegue", sender: nil)
        })
        
    }
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            Logger.log("You've pressed OK button");
        }
        
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    @IBAction func unwindToTeamPromptView(segue: UIStoryboardSegue) { }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreatePromptToJoinTeamSegue" {
            Logger.log("Preparing JoinTeamTableViewController segue...")
            if let dest = segue.destination as? CreateAccountJoinTeamTableViewController {
                dest.userDictionary = self.userDictionary
                dest.teamsArray = self.teams
            }
        }
        
        if segue.identifier == "CreateAccountCreateTeam" {
            Logger.log("Preparing CreateAccountCreateTeam segue...")
            if let dest = segue.destination as? CreateAccountCreateTeamViewController {
                dest.userDictionary = self.userDictionary
            }
        }
    }

}
