//
//  TaskChangeTeamTableViewController.swift
//  DelegationApp
//
//  Created by Erik Phillips on 3/4/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import UIKit

class TaskChangeTeamTableViewController: UITableViewController {
    
    var teams: [Team]?
    private var selectedTeam: Team?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if let teams = self.teams {
            if teams.count > 0 {
                self.tableView.separatorStyle = .singleLine
                numOfSections = 1
                self.tableView.backgroundView = nil
            }
        }
        
        if numOfSections == 0 {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "No other teams available."
            noDataLabel.textColor = Globals.UIGlobals.Colors.PRIMARY
            noDataLabel.textAlignment = .center
            self.tableView.backgroundView = noDataLabel
            self.tableView.separatorStyle = .none
        }
        
        return numOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let teams = self.teams {
            return teams.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskChangeTeamCell", for: indexPath)

        if let teams = self.teams {
            cell.textLabel?.text = teams[indexPath.row].getGUID()
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let teams = self.teams {
            self.selectedTeam = teams[indexPath.row]
            self.performSegue(withIdentifier: "UnwindTeamsToTaskDetail", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UnwindTeamsToTaskDetail" {
            if let dest = segue.destination as? TaskDetailTableViewController {
                dest.selectedTeam = self.selectedTeam
            }
        }
    }

}
