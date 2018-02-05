//
//  JoinTeamTableViewController.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/16/17.
//  Copyright © 2017-2018 Erik Phillips. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountJoinTeamTableViewController: UITableViewController {

    var teamsArray: [Team]?
    var userDictionary: [String: String]?
    
    var selectedTeams: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.log("JoinTeamTableViewController loaded...")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        Logger.log("Done button pressed")
        
        if let dict = self.userDictionary {
            FirebaseUtilities.createNewUser(email: dict["email"]!, password: dict["password"]!, callback: {
                [weak self] (uuid, status) in
                guard let this = self else { return }
                if status.status {
                    Logger.log("new user created: \(uuid)")
                    let user = User(uuid: uuid, firstname: dict["firstname"]!, lastname: dict["lastname"]!, phoneNumber: dict["phone"]!, emailAddress: dict["email"]!)
                    this.performSegue(withIdentifier: "unwindTeamSelectionToWelcome", sender: nil)
                } else {
                    Logger.log("error creating a new user in firebase - \(status.message)", event: .error)
                    this.displayAlert(title: "Error Creating Account", message: status.message)
                }
            })
        } else {
            Logger.log("unable to unwrap user dictionary object", event: .error)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let teams = teamsArray {
            return teams.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamSelectionCell", for: indexPath) as! CreateAccountJoinTeamTableViewCell

        if let teams = teamsArray {
            cell.titleLabel.text = teams[indexPath.row].getTeamName()
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CreateAccountJoinTeamTableViewCell
        if cell.isCellSelected {
            cell.isCellSelected = false
        } else {
            cell.isCellSelected = true
        }
    }
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            Logger.log("You've pressed OK button");
        }
        
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}
