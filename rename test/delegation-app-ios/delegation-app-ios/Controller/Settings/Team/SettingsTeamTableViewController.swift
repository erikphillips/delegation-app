//
//  SettingsTeamTableViewController.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 1/4/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import UIKit

class SettingsTeamTableViewController: UITableViewController {
    
    var user: User?
    var teams: [Team]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = Globals.UIGlobals.Colors.PRIMARY
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControlEvents.valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        self.tableView.reloadData()

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            refreshControl.endRefreshing()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let teams = self.user?.getTeams() {
            return teams.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTeamCell", for: indexPath)

        if let teams = self.user?.getTeams() {
            cell.textLabel?.text = teams[indexPath.row].getTeamName()
            cell.detailTextLabel?.text = "Your Role: "
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let leave = UITableViewRowAction(style: .normal, title: "Leave") { action, index in
            Logger.log("leave button tapped")
            
            let alertController = UIAlertController(title: "Leave Team", message: "Would you like to leave this team? This action is permanent and cannot be undone.", preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in Logger.log("Cancel account deletetion button pressed.")}
            let destroyAction = UIAlertAction(title: "Leave Team", style: .destructive) {
                [editActionsForRowAt, weak self] action in
                guard let this = self else { return }
                Logger.log("Leave team button pressed.")
                if let user = this.user {
                    user.leaveTeam(guid: user.getTeams()[editActionsForRowAt.row].getGUID())
                }
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(destroyAction)
            
            self.present(alertController, animated: true)
        }
        
        leave.backgroundColor = .red
        return [leave]
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
