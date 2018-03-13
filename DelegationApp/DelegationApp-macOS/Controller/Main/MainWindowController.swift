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
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    @IBOutlet weak var toolbarSegmentedFiltering: NSSegmentedControl!
    @IBAction func toolbarSegmentedFilteringPressed(_ sender: Any) {
        Logger.log("segmentControlPressed - \(toolbarSegmentedFiltering.selectedSegment)")
        switch self.toolbarSegmentedFiltering.selectedSegment {
        case 0:  // Perform action for "Personal"
            return
        case 1:  // Perform action for "Team"
            return
        case 2:  // Perform action for "Delegate"
            return
        default:
            return
        }
    }
    
    @IBAction func toolbarSearchBtnPressed(_ sender: Any) {
        Logger.log("search button pressed")
    }
    
    @IBAction func toolbarRefreshBtnPressed(_ sender: Any) {
        Logger.log("refresh button pressed")
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
