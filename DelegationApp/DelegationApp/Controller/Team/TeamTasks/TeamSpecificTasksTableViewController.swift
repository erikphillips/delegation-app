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
        
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.tintColor = Globals.UIGlobals.Colors.PRIMARY
        self.tableView.refreshControl?.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Logger.log("team specific task table view will appear, reloading data")
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func refresh(sender: AnyObject) {
        self.tableView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.tableView.refreshControl?.endRefreshing()
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if let team = self.team {
            if team.getTasks().count > 0 {
                self.tableView.separatorStyle = .singleLine
                numOfSections = 1
                self.tableView.backgroundView = nil
            }
        }
        
        if numOfSections == 0 {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "No tasks within team."
            noDataLabel.textColor = Globals.UIGlobals.Colors.PRIMARY
            noDataLabel.textAlignment = .center
            self.tableView.backgroundView = noDataLabel
            self.tableView.separatorStyle = .none
        }
        
        return numOfSections
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
            if let dest = segue.destination as? TaskDetailTableViewController {
                if let task = sender as? Task {
                    Logger.log("TeamSpecificTaskDetailSegue called to shared TaskDetailTableViewController")
                    dest.task = task
                }
            }
        }
    }

}
