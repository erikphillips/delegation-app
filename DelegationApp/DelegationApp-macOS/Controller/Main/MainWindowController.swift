//
//  MainWindowController.swift
//  DelegationApp-macOS
//
//  Created by Erik Phillips on 3/12/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, NSToolbarDelegate {
    @IBOutlet weak var toolbar: NSToolbar!
    
    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    @IBOutlet weak var testCustomToolbarItem: NSWindow!
    
    @IBAction func customBtnPressed(_ sender: Any) {
        Logger.log("custom button pressed")
    }
}
