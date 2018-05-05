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
    var filteringSelectedSegment: String?
    var filteringFunctionID: String?
    var filteringSelectedTeamname: String?
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(onRequestRefreshNotification(notification:)), name: ObservableNotifications.NOTIFICATION_REQUEST_REFRESH, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onPredictionsLoadedNotification(notification:)), name: ObservableNotifications.NOTIFICATION_PREDICTIONS_LOADED, object: nil)
        
        self.filteringFunctionID = "all_teams"
        self.filteringSelectedSegment = "personal"
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
            switch segment {
                case 0: self.filteringSelectedSegment = "personal"
                case 1: self.filteringSelectedSegment = "team"
                case 2: self.filteringSelectedSegment = "delegation"
                default: Logger.log("unknown selected segment=\(segment)")
            }
            self.refresh()
        }
    }
    
    @objc func onAllTeamSelectionNotification(notification: Notification) {
        Logger.log("all teams selected notification recieved in MainView")
        self.filteringFunctionID = "all_teams"
        self.filteringSelectedTeamname = nil
        self.refresh()
    }
    
    @objc func onTeamSelectionNotification(notification: Notification) {
        if let teamname = notification.userInfo?["teamname"] as? String {
            Logger.log("teams selected notification received for \(teamname)")
            self.filteringFunctionID = "specific_team"
            self.filteringSelectedTeamname = teamname
            self.refresh()
        }
    }

    @objc func onRequestRefreshNotification(notification: Notification) {
        if (self.filteringSelectedSegment == "delegation") {
            self.refresh()
        }
    }
    
    @objc func onPredictionsLoadedNotification(notification: Notification) {
        self.refresh()
    }
    
    func refresh() {
        Logger.log("refreshing mainview table")
        
        self.displayedTasks = []
        var currentStepTasks: [Task] = []
        
        if let segment = self.filteringSelectedSegment {
            if segment == "personal" {
                if let user = self.user {
                    currentStepTasks = user.getTasks()
                }
            } else if segment == "team" {
                if let user = self.user {
                    for team in user.getTeams() {
                        for task in team.getTasks() {
                            currentStepTasks.append(task)
                        }
                    }
                }
            } else if segment == "delegation" {
                if let user = self.user {
                    currentStepTasks = user.getRecommendedTasks()
                }
            } else {
                Logger.log("unknown segment", event: .error)
            }
        }
        
        if let id = self.filteringFunctionID {
            if id == "all_teams" {
                self.displayedTasks = currentStepTasks
            } else if id == "specific_team" {
                if let teamname = self.filteringSelectedTeamname {
                    self.displayedTasks = Utilities.Filtering.filter(tasks: currentStepTasks, by: teamname)
                }
            } else {
                Logger.log("unknown filteringFunctionID")
            }
        }
        
        self.mainTableView.reloadData()
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
            
            // Uncomment the following to allow for automatic updates
            // task.observers.observe(canary: self, callback: updateTaskContents)
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
