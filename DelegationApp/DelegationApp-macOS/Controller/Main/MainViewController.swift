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
    
    @IBOutlet weak var mainTableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Logger.log("MainViewController viewDidLoad")
        
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        
        self.mainTableView.doubleAction = #selector(DeprecatedMainViewController.doubleClickRow)
    }
    
    override func viewWillAppear() {
        Logger.log("MainViewController viewWillAppear")
        self.mainTableView.reloadData()
    }
    
    func refresh() {
        self.mainTableView.reloadData()
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if let tasks = self.user?.getTasks() {
            return tasks.count
        }
        return 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?{
        let result = self.mainTableView.makeView(withIdentifier: (tableColumn?.identifier)!, owner: self) as! NSTableCellView
        let identifier = tableColumn?.identifier.rawValue ?? "error"
        
        if let task = self.user?.getTasks()[row] {
            
            let updateTaskContents = {
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
                        contentVC.task = self.user?.getTasks()[row]
                    }
                }
            }
        }
    }
    
}
