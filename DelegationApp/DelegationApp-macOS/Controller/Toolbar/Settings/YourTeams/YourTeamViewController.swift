//
//  YourTeamViewController.swift
//  DelegationApp-macOS
//
//  Created by Erik Phillips on 3/13/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import Cocoa

class YourTeamViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    var user: User?
    var teams: [Team]?
    var cells: [YourTeamTableViewCell] = []

    @IBOutlet weak var teamTableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.log("YourTeamViewController viewDidLoad")
        
        self.teamTableView.delegate = self
        self.teamTableView.dataSource = self
        
        self.cells = []
    }
    
    @IBAction func leaveSelectedBtnPressed(_ sender: Any) {
        Logger.log("leaveSelectedBtnPressed")
        if let user = self.user {
            for cell in self.cells {
                if cell.checkbox.state == .on {
                    user.leaveTeam(guid: cell.teamNameTextField.stringValue)
                }
            }
            self.dismissViewController(self)
        }
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        Logger.log("cancelBtnPressed")
        self.dismissViewController(self)
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if let teams = self.teams {
            return teams.count
        }
        return 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let result = self.teamTableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "YourTeamCell"), owner: self) as! YourTeamTableViewCell
        
        if let teams = self.teams {
            result.teamNameTextField.stringValue = teams[row].getTeamName()
            result.checkbox.state = .off
            self.cells.append(result)
        }
        
        return result
    }
    
}
