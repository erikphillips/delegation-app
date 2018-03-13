//
//  HeaderViewController.swift
//  DelegationApp-macOS
//
//  Created by Erik Phillips on 3/9/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import Cocoa

class HeaderViewController: NSViewController {
    
    @IBOutlet weak var segmentControl: NSSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.log("HeaderViewController viewDidLoad")
    }
    
    @IBAction func segmentControlPressed(_ sender: Any) {
        Logger.log("segmentControlPressed - \(segmentControl.selectedSegment)")
        switch self.segmentControl.selectedSegment {
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
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        Logger.log("searchButtonPressed")
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {
        Logger.log("refreshButtonPressed")
    }
    
    @IBAction func newTaskButtonPressed(_ sender: Any) {
        Logger.log("newTaskButtonPressed")
    }
    
    @IBAction func createNewTeamButtonPressed(_ sender: Any) {
        Logger.log("createNewTeamButtonPressed")
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        Logger.log("settingsButtonPressed")
    }
    
}
