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
    private var tasks: [TaskSnapshot] = []
    private var teams: [TeamSnapshot] = []
    private var users: [UserSnapshot] = []
    
    private var setupComplete = false
    var setupCallback: (() -> Void)? {
        didSet {
            if setupComplete {
                setupCallback?()
            }
        }
    }
    
    init(targetUUID: String) {
        DelegationSnapshot.downloadData {
            [targetUUID, weak self] (snapshot) in
            guard let this = self else { return }
            
            Logger.log("Snapshot download completed")
            
            this.users = snapshot?.users ?? []
            this.tasks = snapshot?.tasks ?? []
            this.teams = snapshot?.teams ?? []
            
            for user in this.users {
                if user.uuid == targetUUID {
                    this.targetUser = user
                    break
                }
            }
            
            if !this.setupComplete {
                this.setupComplete = true
                this.setupCallback?()
            }
        }
    }
    
    public func getInfoString() -> String {
        return "tasks_count=\(self.tasks.count), teams_count=\(self.teams.count), users_count=\(self.users.count), target_user=\(self.targetUser?.uuid ?? "nil")"
    }
    
    private var predictionComplete = false
    var predictionCallback: (() -> Void)? {
        didSet {
            if predictionComplete {
                predictionCallback?()
            }
        }
    }
    
    public func getPredictedTasks() -> [String] {
        guard let targetUser = self.targetUser else { return [] }
        var pred: [String] = []
        
        let teams: [TeamSnapshot] = self.teams.filter({ targetUser.teams.contains($0.guid) })
        for team in teams {
            let filteredUsers: [UserSnapshot] = self.users.filter({ $0.teams.contains(team.guid) })
            
            var filteredTasks: [TaskSnapshot] = []
            for user in filteredUsers {
                for tuid in user.tasks {
                    if let task = self.tasks.first(where: { $0.tuid == tuid }) {
                        if task.status == "open" {
                            filteredTasks.append(task)
                        }
                    }
                }
            }
            
            pred.append(contentsOf: filteredTasks.map({ $0.tuid }))
        }
        
        return pred
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
    public let title: String
    public let description: String
    public let status: String
    
    init(tuid: String, title: String, description: String, status: String) {
        self.tuid = tuid
        self.title = title
        self.description = description
        self.status = status
    }
}

private class TeamSnapshot {
    public let guid: String
    
    init(guid: String) {
        self.guid = guid
    }
}

private class DelegationSnapshot {
    
    public var users: [UserSnapshot]
    public var tasks: [TaskSnapshot]
    public var teams: [TeamSnapshot]
    
    init(users: [UserSnapshot], teams: [TeamSnapshot], tasks: [TaskSnapshot]) {
        self.users = users
        self.tasks = tasks
        self.teams = teams
    }
    
    public static func downloadData(callback: @escaping ((_ snapshot: DelegationSnapshot?) -> Void)) {
        let ref = Database.database().reference()
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            callback(DelegationSnapshot.parseFBSnapshot(snapshot: snapshot))
        }) { (error) in
            print(error.localizedDescription)
            callback(nil)
        }
    }
    
    private static func parseFBSnapshot(snapshot: DataSnapshot) -> DelegationSnapshot {
        var users: [UserSnapshot] = []
        var tasks: [TaskSnapshot] = []
        var teams: [TeamSnapshot] = []
        
        if let dict = snapshot.value as? NSDictionary {
            if let usersDict = dict["users"] as? NSDictionary {
                users = DelegationSnapshot.parseFBUsers(usersDict)
            }
            
            if let tasksDict = dict["tasks"] as? NSDictionary {
                tasks = DelegationSnapshot.parseFBTasks(tasksDict)
            }
            
            if let teamsDict = dict["teams"] as? NSDictionary {
                teams = DelegationSnapshot.parseFBTeams(teamsDict)
            }
        }
        
        return DelegationSnapshot(users: users, teams: teams, tasks: tasks)
    }
    
    private static func parseFBUsers(_ dict: NSDictionary) -> [UserSnapshot] {
        var users: [UserSnapshot] = []
        
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
                    
                    users.append(UserSnapshot(uuid: uuid, tasks: uTasks, teams: uTeams))
                }
            }
        }
        
        return users
    }
    
    private static func parseFBTasks(_ dict: NSDictionary) -> [TaskSnapshot] {
        var tasks: [TaskSnapshot] = []
        
        for (tuid, value) in dict {
            if let tuid = tuid as? String {
                if let value = value as? NSDictionary {
                    tasks.append(TaskSnapshot(tuid: tuid, title: value["title"] as? String ?? "", description: value["description"] as? String ?? "", status: value["status"] as? String ?? ""))
                }
            }
        }
        
        return tasks
    }
    
    private static func parseFBTeams(_ dict: NSDictionary) -> [TeamSnapshot] {
        var teams: [TeamSnapshot] = []
        
        for (guid, _) in dict {
            if let guid = guid as? String {
                teams.append(TeamSnapshot(guid: guid))
            }
        }
        
        return teams
    }
}
