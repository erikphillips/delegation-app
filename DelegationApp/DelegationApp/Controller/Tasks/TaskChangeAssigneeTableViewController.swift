//
//  TaskChangeAssigneeTableViewController.swift
//  DelegationApp
//
//  Created by Erik Phillips on 3/3/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import UIKit

class TaskChangeAssigneeTableViewController: UITableViewController {
    
    var users: [User]?
    private var selectedAssignee: User?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if let users = self.users {
            if users.count > 0 {
                self.tableView.separatorStyle = .singleLine
                numOfSections = 1
                self.tableView.backgroundView = nil
            }
        }
        
        if numOfSections == 0 {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "No other users available."
            noDataLabel.textColor = Globals.UIGlobals.Colors.PRIMARY
            noDataLabel.textAlignment = .center
            self.tableView.backgroundView = noDataLabel
            self.tableView.separatorStyle = .none
        }
        
        return numOfSections
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let users = self.users {
            return users.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskChangeAssigneeCell", for: indexPath)
        if let users = self.users {
            cell.textLabel?.text = users[indexPath.row].getFullName()
            cell.detailTextLabel?.text = users[indexPath.row].getEmailAddress()
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let users = self.users {
            self.selectedAssignee = users[indexPath.row]
            self.performSegue(withIdentifier: "UnwindAssigneesToTaskDetail", sender: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UnwindAssigneesToTaskDetail" {
            if let dest = segue.destination as? TaskDetailTableViewController {
                dest.selectedAsssignee = self.selectedAssignee
            }
        }
    }

}
