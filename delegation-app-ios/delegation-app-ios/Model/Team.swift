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
    private var teamname : String
    private var description: String
    private var members : [String]
    private var owner : String
    private var guid: String
    
    public var observers = FBObservers<Team>()
    
    init() {
        self.teamname = Globals.TeamGlobals.DEFAULT_TEAMNAME
        self.description = Globals.TeamGlobals.DEFAULT_DESCRIPTION
        self.owner = Globals.TeamGlobals.DEFAULT_OWNER
        
        self.members = Globals.TeamGlobals.DEFAULT_MEMBERS
        self.guid = Globals.TeamGlobals.DEFAULT_GUID
        
        Logger.log("create a new non-observable team")
    }
    
    init(guid: String) {
        self.teamname = Globals.TeamGlobals.DEFAULT_TEAMNAME
        self.description = Globals.TeamGlobals.DEFAULT_DESCRIPTION
        self.owner = Globals.TeamGlobals.DEFAULT_OWNER
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
            this.owner = value?["owner"] as? String ?? this.owner
            
            this.observers.notify(this)
        })
    }
    
    init(teamname: String, description: String, owner: String) {
        self.guid = teamname
        self.teamname = teamname
        self.description = description
        self.owner = owner
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
        return self.owner
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
                self.owner = owner
                ref.child("owner").setValue(owner)
            }
            
            // Notify all observers that an update has occurred
            self.observers.notify(self)
            
        } else {
            Logger.log("unable to update team in database - no guid other than default", event: .error)
        }
    }
}
