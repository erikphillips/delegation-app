//
//  TaskDetailSelectTeam.swift
//  DelegationApp-macOS
//
//  Created by Erik Phillips on 3/27/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import Cocoa

class TaskDetailSelectTeamViewController: NSViewController,NSTableViewDelegate, NSTableViewDataSource  {
    
    var teams: [Team]?
    var rootViewController: TaskDetailViewController?

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var loadingIndicator: NSProgressIndicator!
    @IBOutlet weak var selectBtn: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.doubleAction = #selector(TaskDetailSelectTeamViewController.doubleClickRow)

        self.tableView.isHidden = true
        self.loadingIndicator.startAnimation(nil)
        FirebaseUtilities.fetchAllTeams { [weak self] (teams) in
            guard let this = self else { return }
            this.teams = teams
            this.loadingIndicator.stopAnimation(nil)
            this.tableView.isHidden = false
            this.tableView.reloadData()
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if let teams = self.teams {
            return teams.count
        }
        return 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let result = self.tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "GenericTableCell"), owner: self) as! GenericTableCellView
        
        if let teams = self.teams {
            result.team = teams[row]
            result.textField?.stringValue = teams[row].getGUID()
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
            if let team = self.teams?[selectedRow] {
                self.rootViewController?.selectedNewTeam = team
                self.rootViewController?.reloadViewElements()
                self.dismiss(nil)
            }
        }
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        self.dismiss(nil)
    }
    
}
