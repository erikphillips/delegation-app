//
//  JoinTeamTableViewController.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/16/17.
//  Copyright © 2017-2018 Erik Phillips. All rights reserved.
//

import UIKit
import Firebase

class JoinTeamTableViewController: UITableViewController {

    var teamsArray: [Team]?
    var userDictionary: [String: String]?
    
    var selectedTeams: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.log("JoinTeamTableViewController loaded...")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        Logger.log("Done button pressed")
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! JoinTeamTableViewCell
        if cell.isCellSelected {
            cell.isCellSelected = false
        } else {
            cell.isCellSelected = true
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindWithTeamSelection" {
            if let dest = segue.destination as? JoinTeamViewController {
                if let teams = self.teamsArray {
                    self.selectedTeams = []
                    for (index, element) in teams.enumerated() {
                        Logger.log("idx=\(index) elem=\(element)")
                        let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! JoinTeamTableViewCell
                        if cell.isCellSelected {
                            Logger.log("Cell is selected")
                            // TODO: Fix this to work with the new API
//                            self.selectedTeams?.append(element.getUid())
                        }
                    }
                }
                
                dest.selectedTeams = self.selectedTeams
            }
        }
    }

}
