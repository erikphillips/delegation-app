//
//  Task.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/10/17.
//  Copyright © 2017 Erik Phillips. All rights reserved.
//

import Foundation

class Task {
    private var information : TaskInformation
    private var assigned : [User]
    
    init(information: TaskInformation) {
        self.information = information
        self.assigned = []
    }
}

class TaskInformation {
    private var taskname : String
    private var summary : String
    private var priority : Int
    private var description : String
    
    init(taskname: String) {
        self.taskname = taskname
        self.summary = ""
        self.priority = 5
        self.description = ""
    }
    
    init(taskname: String, summary: String, priority: Int, description: String) {
        self.taskname = taskname
        self.summary = summary
        self.priority = priority
        self.description = description
    }
}
