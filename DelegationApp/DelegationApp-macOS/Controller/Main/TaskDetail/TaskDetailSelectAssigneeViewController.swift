//
//  TaskDetailSelectAssigneeViewController.swift
//  DelegationApp-macOS
//
//  Created by Erik Phillips on 3/27/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import Cocoa

class TaskDetailSelectAssigneeViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    var users: [User]?
    var task: Task?
    var rootViewController: TaskDetailViewController?
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var loadingIndicator: NSProgressIndicator!
    @IBOutlet weak var selectBtn: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Logger.log("TaskDetailSelectAssigneeViewController viewDidLoad")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.loadingIndicator.startAnimation(nil)
        self.tableView.isHidden = true
        
        self.tableView.doubleAction = #selector(TaskDetailSelectTeamViewController.doubleClickRow)

        if let task = self.task {
            let team = Team(guid: task.getTeamUID())
            team.setupCallback = {
                [team, weak self] in
                guard let this = self else { return }
                
                this.users = []
                
                let dispatchGroup = DispatchGroup()
                
                for member in team.getMembers() {
                    dispatchGroup.enter()
                    let user = User(uuid: member)
                    user.setupCallback = {
                        [dispatchGroup] in
                        dispatchGroup.leave()
                    }
                    
                    this.users?.append(user)
                }
                
                dispatchGroup.notify(queue: .main) {
                    [weak this] in
                    guard let that = this else { return }
                    that.loadingIndicator.stopAnimation(nil)
                    that.tableView.isHidden = false
                    that.tableView.reloadData()
                }
            }
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if let users = self.users {
            return users.count
        }
        return 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let result = self.tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "GenericTableCell"), owner: self) as! GenericTableCellView
        
        if let users = self.users {
            result.user = users[row]
            result.textField?.stringValue = "\(users[row].getFullName()) (\(users[row].getEmailAddress()))"
        }
        
        return result
    }
    
    @objc func doubleClickRow() {
        Logger.log("doubleClickRow \(self.tableView.clickedRow)")
        self.selectBtnPressed(self)
    }
    
    @IBAction func selectBtnPressed(_ sender: Any) {
        let selectedRow = self.tableView.selectedRow
        if selectedRow >= 0 {
            if let user = self.users?[selectedRow] {
                self.rootViewController?.selectedNewAssignee = user
                self.rootViewController?.reloadViewElements()
                self.dismiss(nil)
            }
        }
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        self.dismiss(nil)
    }
    
}
