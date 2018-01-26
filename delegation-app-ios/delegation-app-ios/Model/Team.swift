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
    
//    init(teamname: String, owner: String) {
//        self.teamname = teamname
//        self.owner = owner
//        self.members = []
//        self.members.append(owner)
//        self.description = ""
//    }
//
//    init(teamname: String, description: String, owner: String) {
//        self.teamname = teamname
//        self.owner = owner
//        self.description = description
//        self.members = []
//        self.members.append(owner)
//    }
//
//    init(teamname: String, uid: String) {
//        self.teamname = teamname
//        self.uid = uid
//        self.members = []
//        self.description = ""
//        self.owner = ""
//    }
    
    init() {
        self.teamname = Globals.TeamGlobals.DEFAULT_TEAMNAME
        self.description = Globals.TeamGlobals.DEFAULT_DESCRIPTION
        self.owner = Globals.TeamGlobals.DEFAULT_OWNER
        
        self.members = Globals.TeamGlobals.DEFAULT_MEMBERS
        self.guid = Globals.TeamGlobals.DEFAULT_GUID
    }
    
    init(guid: String) {
        self.teamname = Globals.TeamGlobals.DEFAULT_TEAMNAME
        self.description = Globals.TeamGlobals.DEFAULT_DESCRIPTION
        self.owner = Globals.TeamGlobals.DEFAULT_OWNER
        self.members = Globals.TeamGlobals.DEFAULT_MEMBERS
        
        self.guid = guid
        
        Logger.log("created new task, waiting on observable for 'teams/\(guid)/information/'", event: .info)
        
        var ref: DatabaseReference!
        ref = Database.database().reference().child("teams/\(guid)/information/")
        
        ref.observe(DataEventType.value, with: {
            [weak self] (snapshot) in
            guard let this = self else { return }
            
            Logger.log("team update recieved from database for 'teams/\(this.guid)/information/", event: .verbose)
            
            let value = snapshot.value as? NSDictionary
            this.teamname = value?["teamname"] as? String ?? this.teamname
            this.description = value?["description"] as? String ?? this.description
            this.owner = value?["owner"] as? String ?? this.owner
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
        return self.owner
    }
    
    func updateTeam(teamname: String?, description: String?, owner: String?) {
        if self.guid != Globals.TeamGlobals.DEFAULT_GUID {
            Logger.log("updating team information in database for 'teams/\(self.guid)/information'", event: .info)
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
        } else {
            Logger.log("unable to update team in database - no guid other than default", event: .error)
        }
    }
}
