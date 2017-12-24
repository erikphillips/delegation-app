//
//  JoinTeamTableViewController.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/16/17.
//  Copyright © 2017 Erik Phillips. All rights reserved.
//

import UIKit
import Firebase

class JoinTeamTableViewController: UITableViewController {

    var teamsArray: [Team]?
    var user: User?
    
    var selectedTeams: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("JoinTeamTableViewController loaded...")
        
//        if let teams = teamsArray {
//            for (index, element) in teams.enumerated() {
//                let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! JoinTeamTableViewCell
//
//            }
//        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        print("Done button pressed")
        self.performSegue(withIdentifier: "unwindWithTeamSelection", sender: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let teams = teamsArray {
            return teams.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamSelectionCell", for: indexPath) as! JoinTeamTableViewCell

        if let teams = teamsArray {
            cell.titleLabel.text = teams[indexPath.row].getTeamName()
        }

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! JoinTeamTableViewCell
        if cell.isCellSelected {
            cell.isCellSelected = true
        } else {
            cell.isCellSelected = false
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindWithTeamSelection" {
            if let dest = segue.destination as? JoinTeamViewController {
                if let teams = self.teamsArray {
                    self.selectedTeams = []
                    for (index, element) in teams.enumerated() {
                        let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! JoinTeamTableViewCell
                        if cell.isCellSelected {
                            self.selectedTeams?.append(element.getUid())
                        }
                    }
                }
                
                dest.selectedTeams = self.selectedTeams
            }
        }
    }

}
