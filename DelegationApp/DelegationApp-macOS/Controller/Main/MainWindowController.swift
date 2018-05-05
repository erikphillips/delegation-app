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
    
    @IBAction func toolbarPredictBtnPressed(_ sender: Any) {
        Logger.log("predict button pressed")
        if let user = self.user {
            Logger.log("getting predictions for user \(user)")
            user.runPredictionAlgorithm(callback: {
                (tasks) in
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    // Let everything settle for 1 second before logging in (this will be fixed with new download APIs)
                    Logger.log("predictions gathered, sending notification")
                    NotificationCenter.default.post(name: ObservableNotifications.NOTIFICATION_PREDICTIONS_LOADED, object: nil, userInfo: [:])
                })
            })
        }
    }
    
    @IBAction func toolbarNewTaskBtnPressed(_ sender: Any) {
        Logger.log("new task pressed")
        self.performSegue(withIdentifier: NSStoryboardSegue.Identifier("ShowNewTaskSegue"), sender: nil)
    }
    
    @IBAction func toolbarNewTeamBtnPressed(_ sender: Any) {
        Logger.log("new team pressed")
        self.performSegue(withIdentifier: NSStoryboardSegue.Identifier("ShowNewTeamSegue"), sender: nil)
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
        
        if segue.identifier?.rawValue == "ShowNewTeamSegue" {
            if let dest = segue.destinationController as? NewTeamWindowController {
                if let contentVC = dest.contentViewController as? NewTeamViewController {
                    Logger.log("ShowNewTeamSegue called")
                    contentVC.user = self.user
                }
            }
        }
        
        if segue.identifier?.rawValue == "ShowNewTaskSegue" {
            if let dest = segue.destinationController as? NewTaskWindowController {
                if let contentVC = dest.contentViewController as? NewTaskViewController {
                    Logger.log("ShowNewTaskSegue called")
                    contentVC.user = self.user
                }
            }
        }
    }
    
}
