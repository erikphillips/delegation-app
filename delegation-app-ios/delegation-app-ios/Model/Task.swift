//
//  Task.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/10/17.
//  Copyright © 2017-2018  Erik Phillips. All rights reserved.
//

import Foundation
import Firebase

enum TaskStatus: String {
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
    private var status: TaskStatus
    private var assigneeUUID: String
    private var originatorUUID: String
    private var uuid: String
    private var tuid: String

    public var observers = FBObservers<Task>()
    
    init() {
        self.title = Globals.TaskGlobals.DEFAULT_TITLE
        self.priority = Globals.TaskGlobals.DEFAULT_PRIORITY
        self.description = Globals.TaskGlobals.DEFAULT_DESCRIPTION
        self.team = Globals.TaskGlobals.DEFAULT_TEAM
        self.status = Globals.TaskGlobals.DEFAULT_STATUS
        self.assigneeUUID = Globals.TaskGlobals.DEFAULT_ASSIGNEE
        self.originatorUUID = Globals.TaskGlobals.DEFAULT_ORIGINATOR
        
        self.uuid = Globals.TaskGlobals.DEFAULT_UUID
        self.tuid = Globals.TaskGlobals.DEFAULT_TUID
        
        Logger.log("created new non-observable task", event: .warning)
    }
    
    init(uuid: String, tuid: String) {
        self.title = Globals.TaskGlobals.DEFAULT_TITLE
        self.priority = Globals.TaskGlobals.DEFAULT_PRIORITY
        self.description = Globals.TaskGlobals.DEFAULT_DESCRIPTION
        self.team = Globals.TaskGlobals.DEFAULT_TEAM
        self.status = Globals.TaskGlobals.DEFAULT_STATUS
        self.assigneeUUID = Globals.TaskGlobals.DEFAULT_ASSIGNEE
        self.originatorUUID = Globals.TaskGlobals.DEFAULT_ORIGINATOR
        
        self.uuid = uuid
        self.tuid = tuid
        
        Logger.log("created new task, waiting on observable for 'tasks/\(uuid)/\(tuid)/'")
        
        var ref: DatabaseReference!
        ref = Database.database().reference().child("tasks/\(uuid)/\(tuid)/")
        
        ref.observe(DataEventType.value, with: {
            [weak self] (snapshot) in
            guard let this = self else { return }
            
            Logger.log("task update recieved from database for 'tasks/\(uuid)/\(tuid)/'", event: .verbose)
            
            let value = snapshot.value as? NSDictionary
            this.title = value?["title"] as? String ?? this.title
            this.priority = value?["priority"] as? String ?? this.priority
            this.description = value?["description"] as? String ?? this.description
            this.team = value?["team"] as? String ?? this.team
            this.status = Task.parseTaskStatus(value?["status"] as? String ?? this.status.rawValue)
            this.assigneeUUID = value?["assignee"] as? String ?? this.assigneeUUID
            this.originatorUUID = value?["originator"] as? String ?? this.originatorUUID
            
            this.observers.notify(this)
        })
    }
    
    init(uuid: String, guid: String, title: String, priority: String, description: String, status: TaskStatus) {
        self.title = title
        self.priority = priority
        self.description = description
        self.team = guid
        self.status = status
        self.assigneeUUID = uuid
        self.originatorUUID = uuid
        
        self.uuid = uuid
        self.tuid = Globals.TaskGlobals.DEFAULT_TUID
        
        Logger.log("Creating new task at: 'tasks/\(uuid)/'")
        
        let taskRef = Database.database().reference(withPath: "tasks/\(uuid)").childByAutoId()
        taskRef.child("title").setValue(title)
        taskRef.child("priority").setValue(priority)
        taskRef.child("description").setValue(description)
        taskRef.child("status").setValue(status.rawValue)
        taskRef.child("assignee").setValue(uuid)
        taskRef.child("originator").setValue(uuid)
        taskRef.child("team").setValue(guid)
        
        let userRef = Database.database().reference(withPath: "users/\(uuid)/current_tasks")
        userRef.childByAutoId().setValue(taskRef.key)
        
        self.observers.notify(self)
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
        return self.status.rawValue
    }
    
    func getAssigneeUUID() -> String {
        return self.assigneeUUID
    }
    
    func getOriginatorUUID() -> String {
        return self.originatorUUID
    }
    
    private static func parseTaskStatus(_ text: String) -> TaskStatus {
        switch text {
        case "closed":
            return .closed
        case "open":
            return .open
        case "assigned":
            return .assigned
        case "inProgress":
            return .inProgress
        default:
            return .none
        }
    }
    
    func updateTask(title: String?, priority: String?, description: String?, team: String?, status: String?, assignee: String?) {
        if self.tuid != Globals.TaskGlobals.DEFAULT_TUID && self.uuid != Globals.TaskGlobals.DEFAULT_UUID {
            Logger.log("updating task information in database for 'tasks/\(self.uuid)/\(self.tuid)'")
            let ref = Database.database().reference(withPath: "tasks/\(self.uuid)/\(self.tuid)")
            
            if let title = title {
                self.title = title
                ref.child("title").setValue(title)
            }
            
            if let priority = priority {
                self.priority = priority
                ref.child("priority").setValue(priority)
            }
            
            if let description = description {
                self.description = description
                ref.child("description").setValue(description)
            }
            
            if let team = team {
                self.team = team
                ref.child("team").setValue(team)
            }
            
            if let title = title {
                self.title = title
                ref.child("title").setValue(title)
            }
            
            if let status = status {
                self.status = Task.parseTaskStatus(status)
                ref.child("status").setValue(status)
            }
            
            if let assignee = assignee {
                self.assigneeUUID = assignee
                ref.child("assignee").setValue(assignee)
                Logger.log("incomplete method - unable to truly assign different user", event: .error)
            }
            
            // Notify all observers of task updates
            self.observers.notify(self)
            
        } else {
            Logger.log("unable to update task in database - no tuid or uuid other than global", event: .error)
        }
    }
}
