//
//  TasksViewController.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/15/17.
//  Copyright © 2017-2018 Erik Phillips. All rights reserved.
//

import UIKit

class TasksViewController: UIViewController {

    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Logger.log("Task Tab View Loaded, information:")
        if let user = user {
            Logger.log("  user loaded usccessfully - tasks count=\(user.getTasks().count)")
        } else {
            Logger.log("  user did not load")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateNewTask" {
            if let dest = segue.destination as? CreateTaskViewController {
                dest.user = self.user
            }
        }
        
        if segue.identifier == "TasksTableEmbededSegue" {
            if let dest = segue.destination as? TasksTableViewController {
                if let user = self.user {
                    dest.user = user
                }
            }
        }
    }

}
