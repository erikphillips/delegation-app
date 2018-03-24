//
//  NewTeamViewController.swift
//  DelegationApp-macOS
//
//  Created by Erik Phillips on 3/13/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import Cocoa

class NewTeamViewController: NSViewController {

    var user: User?
    
    @IBOutlet weak var teamTitleTextField: NSTextField!
    @IBOutlet var teamDescriptionTextView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func createTeamBtnPressed(_ sender: Any) {
        let teamname = Utilities.trimWhitespace(self.teamTitleTextField.stringValue)
        
        if teamname == Globals.TeamGlobals.DEFAULT_TEAMNAME {
            _ = self.displayAlert(title: "Invalid Teamname", message: "Please enter a valid teamname.")
            return
        }
        
        if let user = user {
            FirebaseUtilities.teamNameInUse(teamname: teamname, callback: {
                [weak self] (status) in
                guard let this = self else { return }
                
                if !status.status {
                    _ = this.displayAlert(title: "Invalid Team Name", message: status.message)
                } else {
                    let team = Team(teamname: Utilities.trimWhitespace(this.teamTitleTextField.stringValue), description: this.teamDescriptionTextView.string, owner: user.getUUID())
                    
                    if let user = this.user {
                        user.addNewTeam(guid: team.getGUID())
                    } else {
                        Logger.log("unable to unwrap user to add guid", event: .error)
                    }
                    
                    NotificationCenter.default.post(name: ObservableNotifications.NOTIFICATION_CLOSE_WINDOW_NEW_TEAM, object: nil)
                }
            })
        } else {
            Logger.log("unable to unwrap user object", event: .error)
        }
    }
    
    func displayAlert(title: String, message: String) -> Bool {
        let alert = NSAlert()
        alert.messageText = title
        alert.informativeText = message
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        return alert.runModal() == .alertFirstButtonReturn
    }
}
