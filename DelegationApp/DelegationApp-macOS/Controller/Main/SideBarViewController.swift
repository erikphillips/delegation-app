//
//  SideBarViewController.swift
//  DelegationApp-macOS
//
//  Created by Erik Phillips on 3/9/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import Cocoa

class SideBarViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

//    var teams: [Team]?
    var teams: [String]? = ["One", "Two", "Three"]
    
    @IBOutlet weak var sideTableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.log("SideBarViewController viewDidLoad")
        
        self.sideTableView.delegate = self
        self.sideTableView.dataSource = self
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if let teams = self.teams {
            return teams.count
        }
        return 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?{
        var result: NSTableCellView
        result  = self.sideTableView.makeView(withIdentifier: (tableColumn?.identifier)!, owner: self) as! NSTableCellView
        
        if let teams = self.teams {
            result.textField?.stringValue = teams[row]
        }
        
        return result
    }
    
}
