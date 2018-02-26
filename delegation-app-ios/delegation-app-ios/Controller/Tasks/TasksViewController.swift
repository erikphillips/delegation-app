//
//  TasksViewController.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/15/17.
//  Copyright © 2017-2018 Erik Phillips. All rights reserved.
//

import UIKit

class TasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var user: User?
    
    var refreshControl: UIRefreshControl!
    @IBOutlet weak var taskTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Logger.log("Task Tab View Loaded, information:")
        if let user = self.user {
            Logger.log("  user loaded usccessfully - tasks count=\(user.getTasks().count)")
        } else {
            Logger.log("  user did not load")
        }
        
        self.taskTableView.delegate = self
        self.taskTableView.dataSource = self
        self.taskTableView.rowHeight = 100.0
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.tintColor = Globals.UIGlobals.Colors.PRIMARY
        self.refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
        self.taskTableView.addSubview(refreshControl)
    }
    
    @objc func refresh(sender: AnyObject) {
        self.taskTableView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.refreshControl.endRefreshing()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Logger.log("task table view will appear, reloading data")
        self.taskTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let user = self.user {
            return user.getTasks().count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TasksTableViewCell
        
        if let user = self.user {
            
            let task = user.getTasks()[indexPath.row]
            
            cell.task = task
            cell.taskNameLabel.text = task.getTitle()
            cell.taskAssignedLabel.text = task.getAssigneeFullName()
            cell.taskTeamNameLabel.text = task.getTeamUID()
            cell.taskPriorityLabel.text = task.getPriority()
            cell.taskStatusLabel.text = task.getStatus()
            
            let taskUpdateHandler = {
                [cell] (task: Task) in
                cell.taskNameLabel.text = task.getTitle()
                cell.taskAssignedLabel.text = task.getAssigneeFullName()
                cell.taskTeamNameLabel.text = task.getTeamUID()
                cell.taskPriorityLabel.text = task.getPriority()
                cell.taskStatusLabel.text = task.getStatus()
            }
            
            task.observers.observe(canary: self, callback: taskUpdateHandler)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let more = UITableViewRowAction(style: .normal, title: "More") { action, index in
            Logger.log("more button tapped")
        }
        more.backgroundColor = Globals.UIGlobals.Colors.PRIMARY_LIGHT
        
        let advanceStatus = UITableViewRowAction(style: .normal, title: "<Advance Status>") { action, index in
            Logger.log("advanceStatus button tapped")
        }
        advanceStatus.backgroundColor = Globals.UIGlobals.Colors.PRIMARY
        
        return [advanceStatus, more]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let user = user {
            self.performSegue(withIdentifier: "TasksTableShowTaskDetail", sender: user.getTasks()[indexPath.row])
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateNewTask" {
            if let dest = segue.destination as? CreateTaskViewController {
                dest.user = self.user
            }
        }
        
        if segue.identifier == "TasksTableShowTaskDetail" {
            if let dest = segue.destination as? TaskDetailTableViewController {
                if let task = sender as? Task {
                    Logger.log("TasksTableShowTaskDetail segue launching for row=\(task.getTitle())")
                    dest.task = task
                }
            }
        }
    }
}
