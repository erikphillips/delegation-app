//
//  JoinTeamTableViewController.swift
//  DelegationApp
//
//  Created by Erik Phillips on 12/16/17.
//  Copyright © 2017-2018 Erik Phillips. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountJoinTeamTableViewController: UITableViewController {

    var teamsArray: [Team]?
    var userDictionary: [String: String]?
    
    var selectedTeams: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.log("JoinTeamTableViewController loaded...")
        
//        FirebaseUtilities.fetchAllTeams(callback: {
//            [weak self] (teams) in
//            guard let this = self else { return }
//            
//            this.teamsArray = teams
//            this.tableView.reloadData()
//        })
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
                    
                    Logger.log("will add \(this.selectedTeams.count) selected teams")
                    for guid in this.selectedTeams {
                        user.addNewTeam(guid: guid)
                    }
                    
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
        var numOfSections: Int = 0
        if let teams = self.teamsArray {
            if teams.count > 0 {
                self.tableView.separatorStyle = .singleLine
                numOfSections = 1
                self.tableView.backgroundView = nil
            }
        }
        
        if numOfSections == 0 {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "No teams available to join."
            noDataLabel.textColor = Globals.UIGlobals.Colors.PRIMARY
            noDataLabel.textAlignment = .center
            self.tableView.backgroundView = noDataLabel
            self.tableView.separatorStyle = .none
        }
        
        return numOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let teams = self.teamsArray {
            return teams.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamSelectionCell", for: indexPath) as! CreateAccountJoinTeamTableViewCell
        cell.checkmarkImage.isHidden = !cell.isCellSelected
        cell.accessoryType = .detailButton
        
        if let teams = teamsArray {
            let team = teams[indexPath.row]
            cell.team = team
            cell.titleLabel.text = team.getTeamName()
            
            team.observers.observe(canary: self, callback: {
                [cell] (team: Team) in
                cell.titleLabel.text = team.getTeamName()
                Logger.log("JoinTeamTableView loaded a team updated handler for guid='\(team.getGUID())', name='\(team.getTeamName())'")
            })
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let cell = tableView.cellForRow(at: indexPath) as! CreateAccountJoinTeamTableViewCell
        cell.isCellSelected = !cell.isCellSelected
        cell.checkmarkImage.isHidden = !cell.isCellSelected
        
        if let guid = cell.team?.getGUID() {
            self.selectedTeams.append(guid)
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CreateAccountJoinTeamTableViewCell
        cell.isCellSelected = !cell.isCellSelected
        cell.checkmarkImage.isHidden = !cell.isCellSelected
        
        if let guid = cell.team?.getGUID() {
            if let index = self.selectedTeams.index(of: guid) {
                self.selectedTeams.remove(at: index)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if let teams = self.teamsArray {
            self.performSegue(withIdentifier: "CreateAccountTeamDetailSegue", sender: teams[indexPath.row])
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
    
    func displayLoadingScreen() {
        Logger.log("Displaying loading screen.")
        
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        self.present(alert, animated: true, completion: nil)
    }
    
    func dismissLoadingScreen(callback: @escaping (() -> Void)) {
        Logger.log("Dismissing loading screen...")
        self.dismiss(animated: true, completion: {
            callback()
        })
    }

    @IBAction func unwindToJoinTeamTableView(segue: UIStoryboardSegue) { }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateAccountTeamDetailSegue" {
            if let dest = segue.destination as? CreateAccountTeamDetailTableViewController {
                if let team = sender as? Team {
                    Logger.log("CreateAccountTeamDetailSegue called for guid='\(team.getGUID())'")
                    dest.team = team
                }
            }
        }
    }

}
