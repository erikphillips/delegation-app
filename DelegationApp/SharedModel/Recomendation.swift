//
//  Recomendation.swift
//  DelegationApp
//
//  Created by Erik Phillips on 4/8/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase

class Recomendation {
    private var targetUser: UserSnapshot? = nil
    private var tasks: [TaskSnapshot]? = nil
    private var teams: [TeamSnapshot]? = nil
    private var users: [UserSnapshot]? = nil
    
    init(targetUUID: String) {
        let ss = DelegationSnapshot()
        ss.downloadData {
            Logger.log("Download completed.")
        }
        
    }
}

private class UserSnapshot {
    public let uuid: String
    public var keywords: [String]
    public var tasks: [String]
    public var teams: [String]
    
    init(uuid: String, tasks: [String], teams: [String]) {
        self.uuid = uuid
        self.keywords = []
        self.tasks = tasks
        self.teams = teams
    }
}

private class TaskSnapshot {
    public let tuid: String
    public let assignee: UserSnapshot?
    public let team: TeamSnapshot?
    
    public let title: String
    public let description: String
    public let status: String
    
    init(tuid: String, title: String, description: String, status: String) {
        self.tuid = tuid
        self.assignee = nil
        self.team = nil
        
        self.title = title
        self.description = description
        self.status = status
    }
}

private class TeamSnapshot {
    public let guid: String
    public var users: [UserSnapshot]
    public var tasks: [TaskSnapshot]
    
    init(guid: String) {
        self.guid = guid
        self.users = []
        self.tasks = []
    }
}

private class DelegationSnapshot {
    
    public var users: [UserSnapshot]
    public var tasks: [TaskSnapshot]
    public var teams: [TeamSnapshot]
    
    init() {
        self.users = []
        self.tasks = []
        self.teams = []
    }
    
    public func downloadData(callback: @escaping (() -> Void)) {
        let ref = Database.database().reference()
        ref.observeSingleEvent(of: .value, with: {
            [weak self] (snapshot) in
            guard let this = self else {
                Logger.log("error")
                return }
            this.parseFBSnapshot(snapshot: snapshot)
            callback()
        })
    }
    
    private func parseFBSnapshot(snapshot: DataSnapshot) {
        if let dict = snapshot.value as? NSDictionary {
            if let usersDict = dict["users"] as? NSDictionary {
                parseFBUsers(usersDict)
            }
            
            if let tasksDict = dict["tasks"] as? NSDictionary {
                parseFBTasks(tasksDict)
            }
            
            if let teamsDict = dict["teams"] as? NSDictionary {
                parseFBTeams(teamsDict)
            }
        }
    }
    
    private func parseFBUsers(_ dict: NSDictionary) {
        for (uuid, value) in dict {
            if let uuid = uuid as? String {
                if let value = value as? NSDictionary {
                    var uTeams: [String] = []
                    if let teamsDict = value["teams"] as? NSDictionary {
                        for (guid, _) in teamsDict {
                            if let guid = guid as? String {
                                uTeams.append(guid)
                            }
                        }
                    }
                    
                    var uTasks: [String] = []
                    if let tasksDict = value["tasks"] as? NSDictionary {
                        for (tuid, _) in tasksDict {
                            if let tuid = tuid as? String {
                                uTasks.append(tuid)
                            }
                        }
                    }
                    
                    self.users.append(UserSnapshot(uuid: uuid, tasks: uTasks, teams: uTeams))
                }
            }
        }
    }
    
    private func parseFBTasks(_ dict: NSDictionary) {
        for (tuid, value) in dict {
            if let tuid = tuid as? String {
                if let value = value as? NSDictionary {
                    self.tasks.append(TaskSnapshot(tuid: tuid, title: value["title"] as? String ?? "", description: value["description"] as? String ?? "", status: value["status"] as? String ?? ""))
                }
            }
        }
    }
    
    private func parseFBTeams(_ dict: NSDictionary) {
        for (guid, _) in dict {
            if let guid = guid as? String {
                self.teams.append(TeamSnapshot(guid: guid))
            }
        }
    }
}
