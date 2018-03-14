//
//  YourTeamTableViewCell.swift
//  DelegationApp-macOS
//
//  Created by Erik Phillips on 3/13/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import Cocoa

class YourTeamTableViewCell: NSTableCellView {

    @IBOutlet weak var checkbox: NSButton!
    @IBOutlet weak var teamNameTextField: NSTextField!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
}
