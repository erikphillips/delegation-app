//
//  NewTeamViewController.swift
//  DelegationApp-macOS
//
//  Created by Erik Phillips on 3/13/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import Cocoa

class NewTeamWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
        self.shouldCascadeWindows = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(onLogoutNotification(notification:)), name: ObservableNotifications.NOTIFICATION_APP_LOGOUT, object: nil)
    }
    
    @objc func onLogoutNotification(notification:Notification) {
        Logger.log("logout notification received for NewTeamWindowController")
        self.window?.close()
    }

}
