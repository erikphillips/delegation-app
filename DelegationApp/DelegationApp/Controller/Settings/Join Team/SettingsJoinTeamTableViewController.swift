//
//  SettingsJoinTeamTableViewController.swift
//  DelegationApp
//
//  Created by Erik Phillips on 1/8/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import UIKit

class SettingsJoinTeamTableViewController: UITableViewController {

    var user: User?
    var teams: [Team]?
    
    var selectedTeams: [String] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.navigationItem.rightBarButtonItem  = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed(sender:)))
        
        Logger.log("SettingsJoinTeamtableViewController loaded...")
        
        FirebaseUtilities.fetchAllTeams(callback: {
            [weak self] (teams) in
            guard let this = self else { return }
            
            Logger.log("All teams fetched, reloading data.")
            if let user = this.user {
                this.teams = []
                for team in teams {
                    if !Utilities.userMemberOfTeam(user: user, team: team) {
                        this.teams?.append(team)
                    }
                }
            }
            this.tableView.reloadData()
        })
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.tintColor = Globals.UIGlobals.Colors.PRIMARY
        self.refreshControl!.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refreshControl!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func refresh(sender: AnyObject) {
        self.tableView.reloadData()
        
        Logger.log("reloading data not implemented", event: .warning)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.refreshControl!.endRefreshing()
        }
    }
    
    @objc func donePressed(sender: AnyObject) {
        Logger.log("donePressed in SettingsJoinTeamTableViewController")
        
        if let user = self.user {
            for guid in self.selectedTeams { user.addNewTeam(guid: guid) }
            self.performSegue(withIdentifier: "JoinTeamToMainSettings", sender: nil)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let teams = self.teams {
            return teams.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsJoinTeamCell", for: indexPath) as! SettingsJoinTeamTableViewCell
        cell.checkmarkImage.isHidden = !cell.isCellSelected
//        cell.accessoryType = .detailButton

        if let teams = teams {
            let team = teams[indexPath.row]
            cell.team = team
            cell.teamTitleLabel.text = team.getTeamName()
            
            team.observers.observe(canary: self, callback: {
                [cell] (team: Team) in
                cell.teamTitleLabel.text = team.getTeamName()
                Logger.log("SettingsJoinTeamTableViewController loaded a team updated handler for guid='\(team.getGUID())', name='\(team.getTeamName())'")
            })
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SettingsJoinTeamTableViewCell
        cell.isCellSelected = !cell.isCellSelected
        cell.checkmarkImage.isHidden = !cell.isCellSelected
        
        if let guid = cell.team?.getGUID() {
            self.selectedTeams.append(guid)
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SettingsJoinTeamTableViewCell
        cell.isCellSelected = !cell.isCellSelected
        cell.checkmarkImage.isHidden = !cell.isCellSelected
        
        if let guid = cell.team?.getGUID() {
            if let index = self.selectedTeams.index(of: guid) {
                self.selectedTeams.remove(at: index)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if let teams = self.teams {
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

}
