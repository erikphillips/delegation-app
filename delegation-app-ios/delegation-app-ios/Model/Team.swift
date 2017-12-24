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
    
    private var uid: String?
    
    init(teamname: String, owner: User) {
        self.teamname = teamname
        self.owner = owner
        self.members = []
        self.members.append(owner)
    }
    
    func getTeamName() -> String {
        return self.teamname
    }
    
    func setUid(_ uid: String) {
        self.uid = uid
    }
    
    func getUid() -> String {
        if let uid = self.uid {
            return uid
        } else {
            return ""
        }
    }
}
