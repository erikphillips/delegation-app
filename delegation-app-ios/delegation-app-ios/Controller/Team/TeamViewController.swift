//
//  TeamViewController.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/15/17.
//  Copyright © 2017-2018 Erik Phillips. All rights reserved.
//

import UIKit

class TeamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var user: User?
    
    @IBOutlet weak var teamsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.log("team view controller loaded")
        
        self.teamsTableView.delegate = self
        self.teamsTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func teamsReloadButtonPressed(_ sender: Any) {
        Logger.log("teams reload button pressed")
        self.teamsTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let user = user {
            return user.getTeams().count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamReuseCell", for: indexPath) as! TeamTableViewCell
        
        if let user = user {
            let team = user.getTeams()[indexPath.row]
            cell.team = team
            cell.teamTitleLabel.text = team.getTeamName()
            
            let teamUpdateHandler = {
                [cell] (team: Team) in
                Logger.log("team table view recieved team update for guid=\(team.getGUID())")
                cell.teamTitleLabel.text = team.getTeamName()
            }
            
            team.observers.observe(canary: self, callback: teamUpdateHandler)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let user = self.user {
            let team = user.getTeams()[indexPath.row]
            self.performSegue(withIdentifier: "ShowTeamSpecificTasksSegue", sender: team)
        }
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if let user = self.user {
            let team = user.getTeams()[indexPath.row]
            self.performSegue(withIdentifier: "ShowTeamDetailSegue", sender: team)
        }
    }
    
    @IBAction func unwindToTeamsTableView(segue: UIStoryboardSegue) { }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCreateTeamView" {
            if let dest = segue.destination as? CreateNewTeamViewController {
                Logger.log("ShowCreateTeamView called")
                dest.user = user
            }
        }
        
        if segue.identifier == "ShowTeamDetailSegue" {
            if let dest = segue.destination as? TeamDetailTableViewController {
                if let team = sender as? Team {
                    Logger.log("ShowTeamDetailSegue called")
                    dest.team = team
                }
            }
        }
        
        if segue.identifier == "ShowTeamSpecificTasksSegue" {
            if let dest = segue.destination as? TeamSpecificTasksTableViewController {
                if let team = sender as? Team {
                    Logger.log("ShowTeamSpecificTasksSegue called")
                    dest.team = team
                }
            }
        }
    }

}
