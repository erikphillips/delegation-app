//
//  Task.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/10/17.
//  Copyright © 2017-2018  Erik Phillips. All rights reserved.
//

import Foundation

enum Resolution: String {
    case none
    case open
    case assigned
    case inProgress
    case closed
}

class Task {
    
    private var title: String
    private var priority: String
    private var description: String
    private var team: String
    private var status: String
    private var resolution: Resolution
    private var assignee: String

    init(title: String, priority: String, description: String, team: String, status: String, resolution: String, assignee: String) {
        self.title = title
        self.priority = priority
        self.description = description
        self.team = team
        self.status = status
        self.resolution = Resolution(rawValue: resolution) ?? Resolution.none
        self.assignee = assignee
    }
    
    func getTitle() -> String {
        return self.title
    }
    
    func getPriority() -> String {
        return self.priority
    }
    
    func getDescription() -> String {
        return self.description
    }
    
    func getTeamUID() -> String {
        return self.team
    }
    
    func getStatus() -> String {
        return self.status
    }
    
    func getResolution() -> String {
        return self.resolution.rawValue
    }
    
    func getAssignee() -> String {
        return self.assignee
    }
}
