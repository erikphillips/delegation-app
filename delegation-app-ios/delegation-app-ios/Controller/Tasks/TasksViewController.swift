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
    var tasks: [Task]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Task Tab View Loaded, information:")
        if let user = user {
            print("  user loaded usccessfully")
        } else {
            print("  user did not load")
        }
        
        if let tasks = tasks {
            print("  tasks loaded successfully - \(tasks.count) tasks loaded")
        } else {
            print("  tasks did not load")
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
                if let tasks = self.tasks {
                    dest.tasks = tasks
                }
            }
        }
    }

}
