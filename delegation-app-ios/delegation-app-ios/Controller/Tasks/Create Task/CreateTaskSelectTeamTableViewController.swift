//
//  CreateTaskSelectTeamTableViewController.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 1/15/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import UIKit

class CreateTaskSelectTeamTableViewController: UITableViewController {

    var teams: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let teams = self.teams {
            return teams.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectTeamCell", for: indexPath)
        
        if let teams = self.teams {
            cell.textLabel?.text = teams[indexPath.row]
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let teams = self.teams {
            self.performSegue(withIdentifier: "UnwindBackToCreateTaskView", sender: teams[indexPath.row])
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UnwindBackToCreateTaskView" {
            if let dest = segue.destination as? CreateTaskViewController {
                if let guid = sender as? String {
                    dest.selectedGUID = guid
                }
            }
        }
    }
    

}
