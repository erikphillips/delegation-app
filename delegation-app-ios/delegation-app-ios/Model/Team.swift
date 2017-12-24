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
    private var description: String
    private var members : [String]
    private var owner : String
    
    private var uid: String?
    
    init(teamname: String, owner: String) {
        self.teamname = teamname
        self.owner = owner
        self.members = []
        self.members.append(owner)
        self.description = ""
    }
    
    init(teamname: String, description: String, owner: String) {
        self.teamname = teamname
        self.owner = owner
        self.description = description
        self.members = []
        self.members.append(owner)
    }
    
    init(teamname: String, uid: String) {
        self.teamname = teamname
        self.uid = uid
        self.members = []
        self.description = ""
        self.owner = ""
    }
    
    func getTeamName() -> String {
        return self.teamname
    }
    
    func getDescription() -> String {
        return self.description
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
    
    func getOwnerUUID() -> String {
        return self.owner
    }
}
