//
//  NewTaskWindowController.swift
//  DelegationApp-macOS
//
//  Created by Erik Phillips on 3/13/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import Cocoa

class NewTaskWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
        self.shouldCascadeWindows = true
    
        NotificationCenter.default.addObserver(self, selector: #selector(onLogoutNotification(notification:)), name: ObservableNotifications.NOTIFICATION_APP_LOGOUT, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onCloseWindowNotification(notification:)), name: ObservableNotifications.NOTIFICATION_CLOSE_WINDOW_NEW_TASK, object: nil)
    }
    
    @objc func onLogoutNotification(notification:Notification) {
        Logger.log("logout notification received for NewTaskWindowController")
        self.window?.close()
    }
    
    @objc func onCloseWindowNotification(notification: Notification) {
        Logger.log("close window notification received for NewTaskWindowController")
        self.window?.close()
    }

}
