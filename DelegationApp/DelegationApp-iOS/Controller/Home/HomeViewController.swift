//
//  HomeViewController.swift
//  DelegationApp
//
//  Created by Erik Phillips on 12/15/17.
//  Copyright © 2017-2018 Erik Phillips. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var user: User?

    var refreshControl: UIRefreshControl!
    @IBOutlet weak var taskTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Logger.log("Home view controller loaded...")
        
        if let user = user {
            Logger.log("User data retrieved in HomeController")
            Logger.log(user.toString())
        } else {
            Logger.log("No user recieved for HomeViewController", event: .warning)
        }
        
        self.taskTableView.delegate = self
        self.taskTableView.dataSource = self
        self.taskTableView.rowHeight = 80
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.tintColor = Globals.UIGlobals.Colors.PRIMARY
        self.refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
        self.taskTableView.addSubview(refreshControl)
        
        if let user = self.user {
            user.observers.observe(canary: self, callback: {
                [weak self] (user) in
                guard let this = self else { return }
                Logger.log("updating task table view")
                this.taskTableView.reloadData()
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Logger.log("task table view will appear, reloading data")
        self.taskTableView.reloadData()
    }
    
    @IBAction func refreshBtnPressed(_ sender: Any) {
        if let user = self.user {
            user.runPredictionAlgorithm(callback: {
                [weak self] (tasks) in
                guard let this = self else { return }
                this.refresh(sender: this)
            })
        }
    }
    
    @objc func refresh(sender: AnyObject) {
        self.taskTableView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.refreshControl.endRefreshing()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if let user = self.user {
            if user.getRecommendedTasks().count > 0 {
                self.taskTableView.separatorStyle = .singleLine
                numOfSections = 1
                self.taskTableView.backgroundView = nil
            }
        }
        
        if numOfSections == 0 {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.numberOfLines = 3
            noDataLabel.text = "No prediction results available.\nPlease run predictions to generate results\nif open tasks are available."
            noDataLabel.textColor = Globals.UIGlobals.Colors.PRIMARY
            noDataLabel.textAlignment = .center
            self.taskTableView.backgroundView = noDataLabel
            self.taskTableView.separatorStyle = .none
        }
        
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let user = self.user {
            return user.getRecommendedTasks().count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskPredictionCell", for: indexPath) as! TaskPredictionTableViewCell
        
        if let user = self.user {
            
            let task = user.getRecommendedTasks()[indexPath.row]
            
            cell.task = task
            cell.taskNameLabel.text = task.getTitle()
            cell.taskTeamNameLabel.text = task.getTeamUID()
            cell.taskPriorityLabel.text = task.getPriority()
            cell.taskStatusLabel.text = task.getStatus()
            
            let taskUpdateHandler = {
                [cell] (task: Task) in
                cell.taskNameLabel.text = task.getTitle()
                cell.taskTeamNameLabel.text = task.getTeamUID()
                cell.taskPriorityLabel.text = task.getPriority()
                cell.taskStatusLabel.text = task.getStatus()
            }
            
            task.observers.observe(canary: self, callback: taskUpdateHandler)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        if let user = self.user {
            let task = user.getTasks()[editActionsForRowAt.row]
            
            let more = UITableViewRowAction(style: .normal, title: "More") {
                [task, weak self] action, index in
                guard let this = self else { return }
                
                Logger.log("more editAction tapped for task")
                
                let alertController = UIAlertController(title: "More Settings", message: nil, preferredStyle: .actionSheet)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
                    Logger.log("Cancel button pressed.")
                }
                
                let changeStatusAction = UIAlertAction(title: "Change Status", style: .default) {
                    [task, weak this] action in
                    guard let that = this else { return }
                    
                    let statusAlertController = UIAlertController(title: "Change status from current status of \(task.getStatus())", message: nil, preferredStyle: .actionSheet)
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in Logger.log("Cancel button pressed.") }
                    statusAlertController.addAction(cancelAction)
                    
                    for status in ["Open", "Assigned", "In Progress", "Closed"] {
                        if task.getStatus() != status {
                            let statusAction = UIAlertAction(title: status, style: .default) { [status, task] action in
                                Logger.log("statusAction button pressed for status=\(status).")
                                task.updateTask(title: nil, priority: nil, description: nil, status: status)
                            }
                            statusAlertController.addAction(statusAction)
                        }
                    }
                    
                    that.present(statusAlertController, animated: true)
                }
                
                let changePriorityAction = UIAlertAction(title: "Change Priority", style: .default) {
                    [task, weak this] action in
                    guard let that = this else { return }
                    
                    let priorityAlertController = UIAlertController(title: "Change priority from current priority of \(task.getPriority())", message: nil, preferredStyle: .actionSheet)
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in Logger.log("Cancel button pressed.") }
                    priorityAlertController.addAction(cancelAction)
                    
                    for priority in ["1", "2", "3", "4", "5"] {
                        if task.getPriority() != priority {
                            let priorityAction = UIAlertAction(title: priority, style: .default) { [priority, task] action in
                                Logger.log("priorityAction button pressed for priority=\(priority).")
                                task.updateTask(title: nil, priority: priority, description: nil, status: nil)
                            }
                            priorityAlertController.addAction(priorityAction)
                        }
                    }
                    
                    that.present(priorityAlertController, animated: true)
                }
                
                
                alertController.addAction(cancelAction)
                alertController.addAction(changeStatusAction)
                alertController.addAction(changePriorityAction)
                
                this.present(alertController, animated: true)
            }
            
            more.backgroundColor = Globals.UIGlobals.Colors.PRIMARY_LIGHT
            
            var editActions = [more]
            
            if let nextStatus = task.getNextStatus() {
                let advanceStatus = UITableViewRowAction(style: .normal, title: nextStatus) {
                    [task] action, index in
                    Logger.log("advanceStatus button tapped")
                    task.advanceStatus()
                }
                advanceStatus.backgroundColor = Globals.UIGlobals.Colors.PRIMARY
                
                editActions.append(advanceStatus)
            }
            
            return editActions
        }
        
        return []
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let user = user {
            self.performSegue(withIdentifier: "PredictTasksTableShowTaskDetail", sender: user.getRecommendedTasks()[indexPath.row])
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "PredictTasksTableShowTaskDetail" {
            if let dest = segue.destination as? TaskDetailTableViewController {
                if let task = sender as? Task {
                    Logger.log("PredictTasksTableShowTaskDetail segue launching for row=\(task.getTitle())")
                    dest.task = task
                }
            }
        }
    }

}
