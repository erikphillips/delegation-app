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
    private var owner : User
    
    init(groupname: String, owner: User) {
        self.groupname = groupname
        self.members = []
        self.owner = owner
    }
}
