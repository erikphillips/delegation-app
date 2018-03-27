//
//  NewTaskViewController.swift
//  DelegationApp-macOS
//
//  Created by Erik Phillips on 3/13/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import Cocoa

class NewTaskViewController: NSViewController {

    var user: User?
    
    @IBOutlet weak var taskTitleTextField: NSTextField!
    @IBOutlet weak var taskTeamSelectionButton: NSPopUpButton!
    @IBOutlet weak var taskTeamSelectionIndicator: NSProgressIndicator!
    @IBOutlet var taskDescriptionTextView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.taskTeamSelectionIndicator.startAnimation(nil)
        self.taskTeamSelectionButton.isEnabled = false
        
        FirebaseUtilities.fetchAllTeamGUIDs {
            [weak self] (guids) in
            guard let this = self else { return }
            this.taskTeamSelectionButton.removeAllItems()
            this.taskTeamSelectionButton.addItems(withTitles: guids)
            this.taskTeamSelectionIndicator.stopAnimation(nil)
            this.taskTeamSelectionButton.isEnabled = true
        }
    }
    
    @IBAction func createTaskBtnPressed(_ sender: Any) {
        Logger.log("Create Task button pressed.")
        
        let title = self.taskTitleTextField.stringValue
        let priority = Globals.TaskGlobals.DEFAULT_PRIORITY
        let desc = self.taskDescriptionTextView.string
        let status = TaskStatus.open
        let teamGUID = self.taskTeamSelectionButton.selectedItem?.title ?? Globals.TaskGlobals.DEFAULT_TEAM
        
        if title == "" {
            _ = self.displayAlert(title: "Title Error", message: "Tasks require titles.")
            return
        }
        
        if desc == "" {
            _ = self.displayAlert(title: "Description Error", message: "Tasks need a description.")
            return
        }
        
        if teamGUID == "" || teamGUID == Globals.TeamGlobals.DEFAULT_GUID {
            _ = self.displayAlert(title: "Team Name Error", message: "Tasks need teams.")
            return
        }
        
        if let user = user {
            if user.getUUID() == Globals.UserGlobals.DEFAULT_UUID {
                _ = self.displayAlert(title: "Error Fetching User", message: "An unknown erorr occured when attempting to fetch the UUID.")
            } else {
                _ = Task(uuid: user.getUUID(), guid: teamGUID, title: title, priority: priority, description: desc, status: status)
                Logger.log("Task created successfully, closing window")
                NotificationCenter.default.post(name: ObservableNotifications.NOTIFICATION_CLOSE_WINDOW_NEW_TASK, object: nil)
            }
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
