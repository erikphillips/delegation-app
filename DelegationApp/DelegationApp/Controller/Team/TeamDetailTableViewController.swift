//
//  TeamDetailTableViewController.swift
//  DelegationApp
//
//  Created by Erik Phillips on 2/7/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import UIKit

class TeamDetailTableViewController: UITableViewController {

    var team: Team?
    private var allTeamUsers: [User]?
    var selectedOwner: User?
    
    private var currentlyEditing = false
    private var unsavedChanges = false
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var memberCountLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var ownerActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit Team", style: UIBarButtonItemStyle.plain, target: self, action: #selector(startEditing(sender:)))
        
        if let team = self.team {
            self.titleLabel.text = team.getTeamName()
            self.ownerLabel.text = team.getOwnerFullName()
            self.memberCountLabel.text = team.getMemberCount()
            self.descriptionTextView.text = team.getDescription()
            
            team.observers.observe(canary: self, callback: {
                [weak self] (team) in
                guard let this = self else { return }
                
                this.titleLabel.text = team.getTeamName()
                this.ownerLabel.text = team.getOwnerFullName()
                this.memberCountLabel.text = team.getMemberCount()
                this.descriptionTextView.text = team.getDescription()
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let owner = self.selectedOwner {
            Logger.log("new selected owner label updated")
            self.ownerLabel.text = owner.getFullName()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func startEditing(sender: AnyObject) {
        Logger.log("startEditing button pressed")
        self.toggleEditing()
    }
    
    @objc func endEditing(sender: AnyObject) {
        Logger.log("endEditing button pressed, updating task")
        self.toggleEditing()
        
        self.team?.updateTeam(description: self.descriptionTextView!.text, owner: self.selectedOwner?.getUUID())
    }
    
    func toggleEditing() {
        self.currentlyEditing = !self.currentlyEditing
        
        if self.currentlyEditing {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save Changes", style: UIBarButtonItemStyle.plain, target: self, action: #selector(endEditing(sender:)))
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit Team", style: UIBarButtonItemStyle.plain, target: self, action: #selector(startEditing(sender:)))
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.currentlyEditing && indexPath.section == 0 {
            self.unsavedChanges = true
            switch indexPath.row {
                // case 0 is teamname and is not editable
                case 1: self.editOwnerRow()
                // case 2 is number of team members and is not editable
                case 3: self.editDescriptionRow()
                default: return
            }
        }
    }
    
    func editOwnerRow() {
        Logger.log("editing owner row")
        
        self.ownerActivityIndicator.startAnimating()
        if let team = self.team {
            self.allTeamUsers = []
            let dispatchGroup = DispatchGroup()
            
            for member in team.getMembers() {
                dispatchGroup.enter()
                let user = User(uuid: member)
                user.setupCallback = {
                    [dispatchGroup] in
                    dispatchGroup.leave()
                }
                
                self.allTeamUsers?.append(user)
            }
            
            dispatchGroup.notify(queue: .main) {
                [weak self] in
                guard let this = self else { return }
                this.ownerActivityIndicator.stopAnimating()
                this.performSegue(withIdentifier: "TeamDetailsShowChangeOwner", sender: nil)
            }
        }
    }
    
    func editDescriptionRow() {
        Logger.log("editing description row")
        
        if let team = self.team {
            let alert = UIAlertController(title: "Enter a new team description:", message: nil, preferredStyle: .alert)
            alert.addTextField { [team] (textField) in textField.text = team.getDescription() }
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Update", style: .default, handler: {
                [weak self] (_) in
                guard let this = self else { return }
                this.descriptionTextView.text = alert.textFields?[0].text ?? this.descriptionTextView.text
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func unwindToTeamDetail(segue: UIStoryboardSegue) { }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TeamDetailsShowChangeOwner" {
            if let dest = segue.destination as? TeamChangeOwnerTableViewController {
                Logger.log("TeamDetailsShowChangeOwner segue called")
                dest.users = self.allTeamUsers
            }
        }
    }
}
