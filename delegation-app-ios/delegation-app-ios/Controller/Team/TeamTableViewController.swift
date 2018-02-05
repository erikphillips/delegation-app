//
//  TeamTableViewController.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 2/4/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import UIKit

class TeamTableViewController: UITableViewController {

    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = user {
            Logger.log("TeamTableViewController loaded - user team count=\(user.getTeams().count)")
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let user = user {
            return user.getTeams().count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamReuseCell", for: indexPath) as! TeamTableViewCell

        if let user = user {
            let team = user.getTeams()[indexPath.row]
            cell.team = team
            cell.teamTitleLabel.text = team.getTeamName()
            
            let teamUpdateHandler = {
                [cell] (team: Team) in
                Logger.log("team table view recieved team update for guid=\(team.getGUID())")
                cell.teamTitleLabel.text = team.getTeamName()
            }
            
            team.observers.observe(canary: self, callback: teamUpdateHandler)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
