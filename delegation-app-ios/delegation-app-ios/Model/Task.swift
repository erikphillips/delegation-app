//
//  Task.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/10/17.
//  Copyright © 2017 Erik Phillips. All rights reserved.
//

import Foundation

class Task {
    private var assigned : [User]
    
    private var taskname : String
    private var teamID : String
    private var priority : Int
    private var description : String
    private var state: String
    
    init(name: String, teamID: String, priority: Int, description: String, state: String) {
        self.taskname = name
        self.teamID = teamID
        self.priority = priority
        self.description = description
        self.state = state
        self.assigned = []
    }
    
    func getName() -> String {
        return self.taskname
    }
    
    func getDescription() -> String {
        return self.description
    }
    
    func getPriority() -> Int {
        return self.priority
    }
    
    func getTeamName() -> String {
        return self.teamID
    }
    
    func getAssignedUserNames() -> [String] {
        var rtnUsrs: [String] = []
        for u in assigned {
            rtnUsrs.append(u.getFullName())
        }
        return rtnUsrs
    }
}
