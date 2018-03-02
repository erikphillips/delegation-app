//
//  Group.swift
//  delegation-app-ios
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
    
    init() {
        self.teamname = Globals.TeamGlobals.DEFAULT_TEAMNAME
        self.description = Globals.TeamGlobals.DEFAULT_DESCRIPTION
        self.ownerUUID = Globals.TeamGlobals.DEFAULT_OWNER
        self.ownerFullName = Globals.UserGlobals.DEFAULT_FULL_NAME
        
        self.members = Globals.TeamGlobals.DEFAULT_MEMBERS
        self.guid = Globals.TeamGlobals.DEFAULT_GUID
        
        Logger.log("create a new non-observable team")
    }
    
    init(guid: String) {
        self.teamname = Globals.TeamGlobals.DEFAULT_TEAMNAME
        self.description = Globals.TeamGlobals.DEFAULT_DESCRIPTION
        self.ownerUUID = Globals.TeamGlobals.DEFAULT_OWNER
        self.ownerFullName = Globals.UserGlobals.DEFAULT_FULL_NAME
        self.members = Globals.TeamGlobals.DEFAULT_MEMBERS
        
        self.guid = guid
        
        Logger.log("created new team, waiting on observable for 'teams/\(guid)/'")
        
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
            
            if let dict = value?["members"] as? NSDictionary {
                for (_, value) in dict {
                    if let value = value as? String {
                        if !this.members.contains(value) {
                            this.members.append(value)
                        }
                    }
                }
            }
            
            let ownerRef = Database.database().reference(withPath: "users/\(this.ownerUUID)/information")
            ownerRef.observe(.value, with: {
                [weak this] (snapshot) in
                guard let that = this else { return }
                
                if let value = snapshot.value as? NSDictionary {
                    let first = value["firstname"] as? String ?? Globals.UserGlobals.DEFAULT_FIRSTNAME
                    let last = value["lastname"] as? String ?? Globals.UserGlobals.DEFAULT_LASTNAME
                    that.ownerFullName = first + " " + last
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
        self.observers.notify(self)
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
    
    func loadTeamTasks() {
        
        self.tasks = []
        let dispatchGroup = DispatchGroup()
        
        for uuid in self.members {
            dispatchGroup.enter()
            
            let ref = Database.database().reference(withPath: "tasks/\(uuid)")
            ref.observe(.value, with: {
                [weak self, uuid, dispatchGroup] (snapshot) in
                guard let this = self else {
                    dispatchGroup.leave()
                    return
                }
                
                if let dict = snapshot.value as? NSDictionary {
                    for (key, value) in dict {
                        if let key = key as? String {
                            if let value = value as? NSDictionary {
                                if let teamname = value["team"] as? String {
                                    if teamname == this.guid {
                                        this.tasks.append(Task(uuid: uuid, tuid: key))
                                    }
                                }
                            }
                        }
                    }
                }
                
                dispatchGroup.leave()
            })
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let this = self else { return }
            this.observers.notify(this)
        }
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
