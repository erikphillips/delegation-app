//
//  TeamSpecificTasksTableViewController.swift
//  DelegationApp
//
//  Created by Erik Phillips on 2/7/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import UIKit

class TeamSpecificTasksTableViewController: UITableViewController {

    var team: Team?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        if let team = self.team {
            team.loadTeamTasks()
            team.observers.observe(canary: self, callback: {
                [weak self] (team) in
                guard let this = self else { return }
                Logger.log("updating table view")
                this.tableView.reloadData()
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let team = self.team {
            return team.getTasks().count
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamSpecificTaskCell", for: indexPath) as! TeamSpecificTaskTableViewCell
        
        if let task = self.team?.getTasks()[indexPath.row] {
            cell.task = task
            cell.taskNameLabel.text = task.getTitle()
            cell.priorityLabel.text = task.getPriority()
            cell.statusLabel.text = task.getStatus()
            cell.assigneeLabel.text = task.getAssigneeFullName()
            
            task.observers.observe(canary: self, callback: {
                [cell] (task) in
                
                cell.taskNameLabel.text = task.getTitle()
                cell.priorityLabel.text = task.getPriority()
                cell.statusLabel.text = task.getStatus()
                cell.assigneeLabel.text = task.getAssigneeFullName()
            })
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let team = self.team {
            self.performSegue(withIdentifier: "TeamSpecificTaskDetailSegue", sender: team.getTasks()[indexPath.row])
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TeamSpecificTaskDetailSegue" {
            if let dest = segue.destination as? TeamSpecificTaskDetailViewController {
                if let task = sender as? Task {
                    // dest.user = self.user
                    dest.task = task
                    Logger.log("TeamSpecificTaskDetailSegue called")
                }
            }
        }
    }

}
