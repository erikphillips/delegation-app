//
//  MainViewController.swift
//  DelegationApp-macOS
//
//  Created by Erik Phillips on 3/9/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import Cocoa

class DeprecatedMainViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate  {

//    var tasks: [Task]?
    var tasks: [String]? = ["One", "Two", "Three"]
    
    @IBOutlet weak var mainTableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.log("MainViewController viewDidLoad")
        
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        
        self.mainTableView.doubleAction = #selector(DeprecatedMainViewController.doubleClickRow)
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if let tasks = self.tasks {
            return tasks.count
        }
        return 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?{
        var result: NSTableCellView
        result  = self.mainTableView.makeView(withIdentifier: (tableColumn?.identifier)!, owner: self) as! NSTableCellView
        
        if let tasks = self.tasks {
            result.textField?.stringValue = tasks[row]
        }
        
        return result
    }
    
    @objc func doubleClickRow() {
        Logger.log("doubleClickRow \(self.mainTableView.clickedRow)")
        
        let selectedRow = self.mainTableView.clickedRow
        if selectedRow >= 0 {
            self.performSegue(withIdentifier: NSStoryboardSegue.Identifier("ShowTaskDetailSegue"), sender: nil)
        }
    }
    
}
