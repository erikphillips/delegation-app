//
//  GenericTableCellView.swift
//  DelegationApp-macOS
//
//  Created by Erik Phillips on 3/27/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import Cocoa

class GenericTableCellView: NSTableCellView {

    var user: User?
    var task: Task?
    var team: Team?
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
}
