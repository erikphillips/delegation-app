//
//  Task.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/10/17.
//  Copyright © 2017-2018  Erik Phillips. All rights reserved.
//

import Foundation

class Task {
    
    private var title: String
    private var priority: String
    private var description: String
    private var team: String
    private var status: String
    private var resolution: String
    private var assignee: String

    init(title: String, priority: String, description: String, team: String, status: String, resolution: String, assignee: String) {
        self.title = title
        self.priority = priority
        self.description = description
        self.team = team
        self.status = status
        self.resolution = resolution
        self.assignee = assignee
    }
    
    func getTitle() -> String {
        return self.title
    }
    
    func getDescription() -> String {
        return self.description
    }
    
    func getPriority() -> String {
        return self.priority
    }
    
    func getTeam() -> String {
        return self.team
    }
    
    func getAssignee() -> String {
        return self.assignee
    }
}
