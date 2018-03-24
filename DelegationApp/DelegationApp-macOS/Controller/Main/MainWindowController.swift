//
//  MainWindowController.swift
//  DelegationApp-macOS
//
//  Created by Erik Phillips on 3/12/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, NSToolbarDelegate {
    
    var user: User?
    
    @IBOutlet weak var toolbar: NSToolbar!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        Logger.log("MainWindowController windowDidLoad")
    
        NotificationCenter.default.addObserver(self, selector: #selector(onLogoutNotification(notification:)), name: ObservableNotifications.NOTIFICATION_APP_LOGOUT, object: nil)
    }
    
    @objc func onLogoutNotification(notification:Notification) {
        Logger.log("logout notification received for MainWindowController")
        self.window?.close()
    }
    
    override func windowWillLoad() {
        Logger.log("MainWindowController windowWillLoad")
    }
    
    @IBOutlet weak var toolbarSegmentedFiltering: NSSegmentedControl!
    @IBAction func toolbarSegmentedFilteringPressed(_ sender: Any) {
        Logger.log("segmentControlPressed - \(toolbarSegmentedFiltering.selectedSegment), posting notification")
        NotificationCenter.default.post(name: ObservableNotifications.NOTIFICATION_SEGMENT_CHANGED, object: nil, userInfo: ["segment": self.toolbarSegmentedFiltering.selectedSegment])
    }
    
    @IBAction func toolbarSearchBtnPressed(_ sender: Any) {
        Logger.log("search button pressed")
    }
    
    @IBAction func toolbarRefreshBtnPressed(_ sender: Any) {
        Logger.log("refresh button pressed")
        
        if let contentVC = self.contentViewController as? NSSplitViewController {
            let splitViews = contentVC.splitViewItems
            if let sidebarVC = splitViews[0].viewController as? SidebarViewController {
                Logger.log("sending refresh to sidebarVC content")
                sidebarVC.refresh()
            }

            if let mainContent = splitViews[1].viewController as? MainViewController {
                Logger.log("sending refresh to mainContent VC")
                mainContent.refresh()
            }
        }
    }
    
    @IBAction func toolbarNewTaskBtnPressed(_ sender: Any) {
        Logger.log("new task pressed")
    }
    
    @IBAction func toolbarNewTeamBtnPressed(_ sender: Any) {
        Logger.log("new team pressed")
    }
    
    @IBAction func toolbarSettingsBtnPressed(_ sender: Any) {
        Logger.log("settings pressed")
        self.performSegue(withIdentifier: NSStoryboardSegue.Identifier("ShowAccountSettingsSegue"), sender: nil)
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier?.rawValue == "ShowAccountSettingsSegue" {
            if let dest = segue.destinationController as? SettingsWindowController {
                if let contentVC = dest.contentViewController as? SettingsViewController {
                    Logger.log("ShowAccountSettingsSegue called")
                    contentVC.user = self.user
                    contentVC.updateView()
                }
            }
        }
    }
    
}
