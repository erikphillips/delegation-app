//
//  Group.swift
//  DelegationApp
//
//  Created by Erik Phillips on 12/10/17.
//  Copyright © 2017-2018  Erik Phillips. All rights reserved.
//

import Foundation
import Firebase

class Team {
    private var teamname: String
    private var description: String
    private var members: [String]
    private var ownerUUID: String
    private var ownerFullName: String
    private var guid: String
    
    private var tasks: [Task] = []
    
    public var observers = FBObservers<Team>()
    
    private var setupComplete = false
    var setupCallback: (() -> Void)? {
        didSet {
            if setupComplete {
                setupCallback?()
            }
        }
    }
    
    init() {
        self.teamname = Globals.TeamGlobals.DEFAULT_TEAMNAME
        self.description = Globals.TeamGlobals.DEFAULT_DESCRIPTION
        self.ownerUUID = Globals.TeamGlobals.DEFAULT_OWNER
        self.ownerFullName = Globals.UserGlobals.DEFAULT_FULL_NAME
        
        self.members = Globals.TeamGlobals.DEFAULT_MEMBERS
        self.guid = Globals.TeamGlobals.DEFAULT_GUID
        
        Logger.log("create a new non-observable team")
        
        if !self.setupComplete {
            self.setupComplete = true
            self.setupCallback?()
        }
        
        self.observers.notify(self)
    }
    
    init(guid: String) {
        self.teamname = Globals.TeamGlobals.DEFAULT_TEAMNAME
        self.description = Globals.TeamGlobals.DEFAULT_DESCRIPTION
        self.ownerUUID = Globals.TeamGlobals.DEFAULT_OWNER
        self.ownerFullName = Globals.UserGlobals.DEFAULT_FULL_NAME
        self.members = Globals.TeamGlobals.DEFAULT_MEMBERS
        
        self.guid = guid
        
        Logger.log("created new team, waiting on observable for 'teams/\(guid)/'")
        
        self.observeTasks()
        self.observeMembers()
        
        var ref: DatabaseReference!
        ref = Database.database().reference().child("teams/\(guid)/")
        
        ref.observe(DataEventType.value, with: {
            [weak self] (snapshot) in
            guard let this = self else { return }
            
            Logger.log("team update recieved from database for 'teams/\(this.guid)/", event: .verbose)
            
            let value = snapshot.value as? NSDictionary
            this.teamname = value?["teamname"] as? String ?? this.teamname
            this.description = value?["description"] as? String ?? this.description
            this.ownerUUID = value?["owner"] as? String ?? this.ownerUUID
            
            // Process and load the team owner
            let ownerRef = Database.database().reference(withPath: "users/\(this.ownerUUID)/information")
            ownerRef.observeSingleEvent(of: .value, with: {
                [weak this] (snapshot) in
                guard let that = this else { return }
                
                if let value = snapshot.value as? NSDictionary {
                    let first = value["firstname"] as? String ?? Globals.UserGlobals.DEFAULT_FIRSTNAME
                    let last = value["lastname"] as? String ?? Globals.UserGlobals.DEFAULT_LASTNAME
                    that.ownerFullName = first + " " + last
                }
                
                if !that.setupComplete {
                    that.setupComplete = true
                    that.setupCallback?()
                }
                
                that.observers.notify(that)
            })
        })
    }
    
    init(teamname: String, description: String, owner: String) {
        self.guid = teamname
        self.teamname = teamname
        self.description = description
        self.ownerUUID = owner
        self.ownerFullName = Globals.UserGlobals.DEFAULT_FULL_NAME
        self.members = [owner]
        
        let ref = Database.database().reference(withPath: "teams/\(self.guid)/")
        ref.child("teamname").setValue(teamname)
        ref.child("description").setValue(description)
        ref.child("owner").setValue(owner)
        ref.child("members").childByAutoId().setValue(owner)
        
        Logger.log("create a new non-observable team account in database with guid='\(self.guid)'")
        
        if !self.setupComplete {
            self.setupComplete = true
            self.setupCallback?()
        }
        
        self.observers.notify(self)
    }
    
    func observeTasks() {
        let ref = Database.database().reference(withPath: "teams/\(self.guid)/current_tasks")
        ref.observe(.childAdded, with: {
            [weak self] (snapshot) in
            guard let this = self else { return }
            
            if let tuid = snapshot.value as? String {
                Logger.log("adding new observable task tuid=\"\(tuid)\"")
                this.tasks.append(Task(tuid: tuid))
                this.observers.notify(this)
            }
        })
        
        ref.observe(.childRemoved, with: {
            [weak self] (snapshot) in
            guard let this = self else { return }
            
            if let tuid = snapshot.value as? String {
                for (idx, task) in this.tasks.enumerated() {
                    if task.getTUID() == tuid {
                        Logger.log("removing task idx=\(idx), guid=\"\(tuid)\"")
                        this.tasks.remove(at: idx)
                    }
                }
                
                this.observers.notify(this)
            }
        })
    }
    
    func observeMembers() {
        let ref = Database.database().reference(withPath: "teams/\(self.guid)/members")
        ref.observe(.childAdded, with: {
            [weak self] (snapshot) in
            guard let this = self else { return }
            
            if let uuid = snapshot.value as? String {
                Logger.log("adding new member uuid=\"\(uuid)\"")
                this.members.append(uuid)
                this.observers.notify(this)
            }
        })
        
        ref.observe(.childRemoved, with: {
            [weak self] (snapshot) in
            guard let this = self else { return }
            
            if let uuid = snapshot.value as? String {
                for (idx, member) in this.members.enumerated() {
                    if member == uuid {
                        Logger.log("removing member idx=\(idx), uuid=\"\(uuid)\"")
                        this.members.remove(at: idx)
                    }
                }
                
                this.observers.notify(this)
            }
        })
    }
    
    func getTeamName() -> String {
        return self.teamname
    }
    
    func getDescription() -> String {
        return self.description
    }
    
    func getGUID() -> String {
        return self.guid
    }
    
    func getOwnerUUID() -> String {
        return self.ownerUUID
    }
    
    func getOwnerFullName() -> String {
        return self.ownerFullName
    }
    
    func getMembers() -> [String] {
        return self.members
    }
    
    func getMemberCount() -> String {
        return String(self.members.count)
    }
    
    func getTasks() -> [Task] {
        return self.tasks
    }
    
    func updateTeam(teamname: String?, description: String?, owner: String?) {
        if self.guid != Globals.TeamGlobals.DEFAULT_GUID {
            Logger.log("updating team information in database for 'teams/\(self.guid)/information'")
            let ref = Database.database().reference(withPath: "teams/\(self.guid)/information")
            
            if let teamname = teamname {
                self.teamname = teamname
                ref.child("teamname").setValue(teamname)
            }
            
            if let description = description {
                self.description = description
                ref.child("description").setValue(description)
            }
            
            if let owner = owner {
                self.ownerUUID = owner
                ref.child("owner").setValue(owner)
                
                let ownerRef = Database.database().reference(withPath: "users/\(owner)/teams")
                ownerRef.observeSingleEvent(of: .value, with: {
                    [ownerRef, weak self](snapshot) in
                    guard let this = self else { return }
                    
                    if let dict = snapshot.value as? NSDictionary {
                        var found = false
                        for (_, value) in dict {
                            if let value = value as? String {
                                if value == this.guid {
                                    found = true
                                    break
                                }
                            }
                        }
                        
                        if !found { ownerRef.childByAutoId().setValue(this.guid) }
                        Logger.log("processed new owner ref, previously existing: \(found)")
                    }
                })
            }
            
            // Notify all observers that an update has occurred
            self.observers.notify(self)
            
        } else {
            Logger.log("unable to update team in database - no guid other than default", event: .error)
        }
    }
}
