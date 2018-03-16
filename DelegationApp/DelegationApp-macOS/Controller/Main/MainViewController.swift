//
//  MainViewController.swift
//  DelegationApp-macOS
//
//  Created by Erik Phillips on 3/9/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate  {

    var user: User?
//    var tasks: [Task]?
    var tasks: [String]? = ["One", "Two", "Three"]
    
    @IBOutlet weak var mainTableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.log("MainViewController viewDidLoad")
        
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        
        self.mainTableView.doubleAction = #selector(MainViewController.doubleClickRow)
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
