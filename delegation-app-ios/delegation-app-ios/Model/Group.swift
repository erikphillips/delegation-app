//
//  Group.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/10/17.
//  Copyright © 2017 Erik Phillips. All rights reserved.
//

import Foundation

class Group {
    private var information : GroupInformation
    
    init(information: GroupInformation) {
        self.information = information
    }
}

class GroupInformation {
    private var groupname : String
    private var members : [User]
    
    init(groupname: String) {
        self.groupname = groupname
        self.members = []
    }
}
