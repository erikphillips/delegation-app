//
//  MainViewController.swift
//  DelegationApp-macOS
//
//  Created by Erik Phillips on 3/15/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    var user: User?
    var displayedTasks: [Task]?
    
    @IBOutlet weak var mainTableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Logger.log("MainViewController viewDidLoad")
        
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        
        self.mainTableView.doubleAction = #selector(DeprecatedMainViewController.doubleClickRow)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onSegmentChangedNotification(notification:)), name: ObservableNotifications.NOTIFICATION_SEGMENT_CHANGED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onAllTeamSelectionNotification(notification:)), name: ObservableNotifications.NOTIFICATION_ALL_TEAM_SELECTION, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onTeamSelectionNotification(notification:)), name: ObservableNotifications.NOTIFICATION_TEAM_SELECTION, object: nil)
    }
    
    override func viewWillAppear() {
        Logger.log("MainViewController viewWillAppear")
        
        self.refresh()
        self.user?.observers.observe(canary: self, callback: {
            [weak self] (user) in
            guard let this = self else { return }
            this.refresh()
        })
    }
    
    @objc func onSegmentChangedNotification(notification: Notification) {
        if let segment = notification.userInfo?["segment"] as? Int {
            Logger.log("segment changed notification for new segment=\(segment)")
        }
    }
    
    @objc func onAllTeamSelectionNotification(notification: Notification) {
        Logger.log("all teams selected notification recieved in MainView")
    }
    
    @objc func onTeamSelectionNotification(notification: Notification) {
        if let teamname = notification.userInfo?["teamname"] as? String {
            Logger.log("teams selected notification received for \(teamname)")
        }
    }
    
    func refresh() {
        self.displayedTasks = self.user?.getTasks()
        self.mainTableView.reloadData()
    }
    
    func filteringController() {
        
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if let tasks = self.displayedTasks {
            return tasks.count
        }
        return 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?{
        let result = self.mainTableView.makeView(withIdentifier: (tableColumn?.identifier)!, owner: self) as! NSTableCellView
        let identifier = tableColumn?.identifier.rawValue ?? "error"
        
        if let task = self.displayedTasks?[row] {
            
            let updateTaskContents = {  // this is the callback for updating the task
                [identifier, result] (task: Task) in
                
                switch(identifier) {
                case "TaskTitleCell":
                    result.textField?.stringValue = task.getTitle()
                    break
                case "TaskTeamCell":
                    result.textField?.stringValue = task.getTeamUID()
                    break
                case "TaskAssigneeCell":
                    result.textField?.stringValue = task.getAssigneeFullName()
                    break
                case "TaskOriginatorCell":
                    result.textField?.stringValue = task.getOriginatorFullName()
                    break
                case "TaskStatusCell":
                    result.textField?.stringValue = task.getStatus()
                    break
                case "TaskPriorityCell":
                    result.textField?.stringValue = task.getPriority()
                    break
                default:
                    break
                }
            }
            
            task.observers.observe(canary: self, callback: updateTaskContents)
            updateTaskContents(task)
            
        }
        
        return result
    }
    
    @objc func doubleClickRow() {
        Logger.log("doubleClickRow \(self.mainTableView.clickedRow)")
        
        let selectedRow = self.mainTableView.clickedRow
        if selectedRow >= 0 {
            self.performSegue(withIdentifier: NSStoryboardSegue.Identifier("ShowTaskDetailSegue"), sender: selectedRow)
        }
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier?.rawValue == "ShowTaskDetailSegue" {
            if let dest = segue.destinationController as? TaskDetailWindowController {
                if let contentVC = dest.contentViewController as? TaskDetailViewController {
                    if let row = sender as? Int {
                        Logger.log("ShowTaskDetailSegue called")
                        contentVC.user = self.user
                        contentVC.task = self.displayedTasks?[row]
                    }
                }
            }
        }
    }
    
}
