//
//  Group.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/10/17.
//  Copyright © 2017 Erik Phillips. All rights reserved.
//

import Foundation

class Team {
    private var teamname : String
    private var members : [User]
    private var owner : User
    
    init(teamname: String, owner: User) {
        self.teamname = teamname
        self.owner = owner
        self.members = []
        self.members.append(owner)
    }
}
