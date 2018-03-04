//
//  Task.swift
//  DelegationApp
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
    private var assigneeFullName: String
    private var originatorUUID: String
    private var originatorFullName: String
    private var uuid: String
    private var tuid: String

    public var observers = FBObservers<Task>()
    
    private var setupComplete = false
    var setupCallback: (() -> Void)? {
        didSet {
            if setupComplete {
                setupCallback?()
            }
        }
    }
    
    init() {
        self.title = Globals.TaskGlobals.DEFAULT_TITLE
        self.priority = Globals.TaskGlobals.DEFAULT_PRIORITY
        self.description = Globals.TaskGlobals.DEFAULT_DESCRIPTION
        self.team = Globals.TaskGlobals.DEFAULT_TEAM
        self.status = Globals.TaskGlobals.DEFAULT_STATUS
        self.assigneeUUID = Globals.TaskGlobals.DEFAULT_ASSIGNEE
        self.originatorUUID = Globals.TaskGlobals.DEFAULT_ORIGINATOR
        self.assigneeFullName = Globals.UserGlobals.DEFAULT_FULL_NAME
        self.originatorFullName = Globals.UserGlobals.DEFAULT_FULL_NAME
        
        self.uuid = Globals.TaskGlobals.DEFAULT_UUID
        self.tuid = Globals.TaskGlobals.DEFAULT_TUID
        
        Logger.log("created new empty non-observable task", event: .warning)
        
        if !self.setupComplete {
            self.setupComplete = true
            self.setupCallback?()
        }
        
        self.observers.notify(self)
    }
    
    init(uuid: String, tuid: String) {
        self.title = Globals.TaskGlobals.DEFAULT_TITLE
        self.priority = Globals.TaskGlobals.DEFAULT_PRIORITY
        self.description = Globals.TaskGlobals.DEFAULT_DESCRIPTION
        self.team = Globals.TaskGlobals.DEFAULT_TEAM
        self.status = Globals.TaskGlobals.DEFAULT_STATUS
        self.assigneeUUID = Globals.TaskGlobals.DEFAULT_ASSIGNEE
        self.originatorUUID = Globals.TaskGlobals.DEFAULT_ORIGINATOR
        self.assigneeFullName = Globals.UserGlobals.DEFAULT_FULL_NAME
        self.originatorFullName = Globals.UserGlobals.DEFAULT_FULL_NAME
        
        self.uuid = uuid
        self.tuid = tuid
        
        Logger.log("created new task, waiting on observable for 'tasks/\(tuid)/'")
        
        var ref: DatabaseReference!
        ref = Database.database().reference().child("tasks/\(tuid)/")
        
        ref.observe(.value, with: {
            [weak self] (snapshot) in
            guard let this = self else { return }
            
            Logger.log("task update recieved from database for 'tasks/\(tuid)/'", event: .verbose)
            
            let value = snapshot.value as? NSDictionary
            this.title = value?["title"] as? String ?? this.title
            this.priority = value?["priority"] as? String ?? this.priority
            this.description = value?["description"] as? String ?? this.description
            this.team = value?["team"] as? String ?? this.team
            this.status = Task.parseTaskStatus(value?["status"] as? String ?? this.status.rawValue)
            this.assigneeUUID = value?["assignee"] as? String ?? this.assigneeUUID
            this.originatorUUID = value?["originator"] as? String ?? this.originatorUUID
            
            let assigneeRef = Database.database().reference(withPath: "users/\(this.assigneeUUID)/information")
            let originatorRef = Database.database().reference(withPath: "users/\(this.originatorUUID)/information")
            
            let dispatchGroup = DispatchGroup()
            
            dispatchGroup.enter()
            assigneeRef.observe(.value, with: {
                [dispatchGroup, weak this] (snapshot) in
                guard let that = this else { return }
                if let value = snapshot.value as? NSDictionary {
                    let first = value["firstname"] as? String ?? Globals.UserGlobals.DEFAULT_FIRSTNAME
                    let last = value["lastname"] as? String ?? Globals.UserGlobals.DEFAULT_LASTNAME
                    that.assigneeFullName = first + " " + last
                }
                dispatchGroup.leave()
            })
            
            dispatchGroup.enter()
            originatorRef.observe(.value, with: {
                [dispatchGroup, weak this] (snapshot) in
                guard let that = this else { return }
                if let value = snapshot.value as? NSDictionary {
                    let first = value["firstname"] as? String ?? Globals.UserGlobals.DEFAULT_FIRSTNAME
                    let last = value["lastname"] as? String ?? Globals.UserGlobals.DEFAULT_LASTNAME
                    that.originatorFullName = first + " " + last
                }
                dispatchGroup.leave()
            })
            
            dispatchGroup.notify(queue: .main) {
                [weak this] in
                guard let that = this else { return }
                
                if !that.setupComplete {
                    that.setupComplete = true
                    that.setupCallback?()
                }
                
                that.observers.notify(that)
            }
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
        self.assigneeFullName = Globals.UserGlobals.DEFAULT_FULL_NAME
        self.originatorFullName = Globals.UserGlobals.DEFAULT_FULL_NAME
        
        self.uuid = uuid
        self.tuid = Globals.TaskGlobals.DEFAULT_TUID
        
        let taskRef = Database.database().reference(withPath: "tasks/").childByAutoId()
        Logger.log("Creating new task at: 'tasks/\(taskRef.key)'")
        
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
    
    func getTUID() -> String {
        return self.tuid
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
        switch self.status {
            case .none: return "None"
            case .closed: return "Closed"
            case .open: return "Open"
            case .inProgress: return "In Progress"
            case .assigned: return "Assigned"
        }
    }
    
    func getNextStatus() -> String? {
        switch self.status {
            case .open: return "Assigned"
            case .assigned: return "In Progress"
            case .inProgress: return "Closed"
            default: return nil
        }
    }
        
    func getAssigneeUUID() -> String {
        return self.assigneeUUID
    }
    
    func getAssigneeFullName() -> String {
        return self.assigneeFullName
    }
    
    func getOriginatorUUID() -> String {
        return self.originatorUUID
    }
    
    func getOriginatorFullName() -> String {
        return self.originatorFullName
    }
    
    private static func parseTaskStatus(_ text: String) -> TaskStatus {
        switch text {
            case "closed": return .closed
            case "Closed": return .closed
            case "open": return .open
            case "Open": return .open
            case "assigned": return .assigned
            case "Assigned": return .assigned
            case "inProgress": return .inProgress
            case "In Progress": return .inProgress
            default: return .none
        }
    }
    
    func advanceStatus() {
        if let nextStatus = self.getNextStatus() {
            let ref = Database.database().reference(withPath: "tasks/\(self.uuid)/\(self.tuid)/status")
            
            self.status = Task.parseTaskStatus(nextStatus)
            ref.setValue(self.status.rawValue)
            
            // Notify all observers of task updates
            self.observers.notify(self)
        }
    }
    
    func updateTask(title: String?, priority: String?, description: String?, status: String?) {
        if self.tuid != Globals.TaskGlobals.DEFAULT_TUID && self.uuid != Globals.TaskGlobals.DEFAULT_UUID {
            Logger.log("updating task information in database for 'tasks/\(self.uuid)/\(self.tuid)'")
            let ref = Database.database().reference(withPath: "tasks/\(self.uuid)/\(self.tuid)")
            
            if let title = title {
                if title != self.title {
                    self.title = title
                    ref.child("title").setValue(title)
                }
            }
            
            if let priority = priority {
                if priority != self.priority {
                    self.priority = priority
                    ref.child("priority").setValue(priority)
                }
            }
            
            if let description = description {
                if description != self.description {
                    self.description = description
                    ref.child("description").setValue(description)
                }
            }
            
            if let title = title {
                if title != self.title {
                    self.title = title
                    ref.child("title").setValue(title)
                }
            }
            
            if let status = status {
                if self.status != Task.parseTaskStatus(status) {
                    self.status = Task.parseTaskStatus(status)
                    ref.child("status").setValue(self.status.rawValue)
                }
            }
            
            // Notify all observers of task updates
            self.observers.notify(self)
            
        } else {
            Logger.log("unable to update task in database - no tuid or uuid other than global", event: .error)
        }
    }
    
    func changeAssignee(to uuid: String) {
        let taskRef = Database.database().reference(withPath: "tasks/\(self.tuid)/assignee")
        let oldAssigneeRef = Database.database().reference(withPath: "users/\(self.uuid)/current_tasks/")
        let newAssigneeRef = Database.database().reference(withPath: "users/\(uuid)/current_tasks/")
        
        // Set the new UUID
        self.uuid = uuid
        taskRef.setValue(self.uuid)
        
        // Add the task to the new assignee's array,
        // this should trigger the observable within
        // the new assignee to load the task
        newAssigneeRef.childByAutoId().setValue(self.tuid)
        
        // Remove the task listed under the user's current_tasks
        // which should trigger the old assignee's observable
        // to remove the task from their task array.
        oldAssigneeRef.observeSingleEvent(of: .value, with: {
            [oldAssigneeRef, weak self] (snapshot) in
            guard let this = self else { return }
            
            if let dict = snapshot.value as? NSDictionary {
                for (key, value) in dict {
                    if let key = key as? String, let value = value as? String{
                        if value == this.tuid {
                            Logger.log("removing current_task at key=\(key) value=\(value)")
                            oldAssigneeRef.child(key).removeValue()
                            break
                        }
                    }
                }
            }
        })
        
        self.observers.notify(self)
    }
    
    func changeTeam(to guid: String) {
        let taskRef = Database.database().reference(withPath: "tasks/\(self.tuid)/team")
        taskRef.setValue(guid)
        self.team = guid
        self.observers.notify(self)
    }
}
