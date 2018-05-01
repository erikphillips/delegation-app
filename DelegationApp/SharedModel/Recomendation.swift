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
    
    public func generateKeywords(callback: @escaping (() -> Void)) {
        generateTaskKeywords()
        generateUserKeywords()
        callback()
    }
    
    private func generateTaskKeywords() {
        var documents: [(Int, [String])] = []
        for task in self.tasks {
            documents.append((task.id, task.tokenize()))
        }
        
        let tfidf = self.generateTFIDF(documents: documents)
        for task in self.tasks {
            let values: [(String, Double)] = tfidf.reduce([], { if $1.0 == task.id { return $0 + $1.1 } else { return $0 }}).sorted(by: { $0.1 > $1.1})
            task.keywords = Array(values.filter({ $0.1 > 0 }).prefix(10)).map({$0.0})
        }
    }
    
    private func generateUserKeywords() {
        var documents: [(Int, [String])] = []
        for user in self.users {
            documents.append((user.id, self.tasks.filter({
                user.tasks.contains($0.tuid) && $0.status != "open"  // only take tasks that have status > open
            }).map({ $0.tokenize() }).flatMap({ $0 })))  // tokenize the task and capture the words
        }
        
        let tfidf = self.generateTFIDF(documents: documents)
        for user in self.users {
            let values: [(String, Double)] = tfidf.reduce([], { if $1.0 == user.id { return $0 + $1.1 } else { return $0 }}).sorted(by: { $0.1 > $1.1})
            user.keywords.append(contentsOf: Array(values.filter({ $0.1 > 0 }).prefix(10)).map({$0.0}))
            // append the task keywords to the current user defined ones
        }
    }
    
    private func generateTFIDF(documents: [(Int, [String])]) -> [(Int, [(String, Double)])]{
        let numberOfDocuments = documents.count
        let allTerms: [String] = Array(Set(documents.map({ $0.1 }).flatMap({ $0 })))  // all ordering of terms is lost - okay!
        
        var tf: [(Identity, Double)] = []
        for document in documents {
            for term in allTerms {
                tf.append((Identity(id: document.0, term: term), Double(document.1.reduce(0, { if $1 == term {return $0 + 1} else { return $0}})) / Double(document.1.count)))
            }
        }
        
        var idf: [(String, Double)] = []
        for term in allTerms {
            let numdocs = documents.map({ $0.1 }).reduce(0, { if $1.contains(term) { return $0 + 1 } else { return $0 }})
            idf.append((term, log10(Double(numberOfDocuments) / Double(numdocs))))
        }
        
        var tfidfMatrix: [(Int, [(String, Double)])] = []
        for document in documents {
            var sequence: [(String, Double)] = []
            for term in allTerms {
                let idfValue = idf.reduce([], { if $1.0 == term { return $0 + [$1.1] } else { return $0 }}).first ?? 0.0
                let tfValue = tf.reduce([], { if $1.0.id == document.0 && $1.0.term == term { return $0 + [$1.1] } else { return $0 }}).first ?? 0.0
                sequence.append((term, idfValue * tfValue))
            }
            tfidfMatrix.append((document.0, sequence))
        }
        
        return tfidfMatrix
    }
    
    private class Identity {
        public let id: Int
        public let term: String
        init(id: Int, term: String) {
            self.id = id
            self.term = term
        }
    }
    
    public func getPredictedTasks(callback: @escaping ((_ tasks: [String]) -> Void)) {
        guard let targetUser = self.targetUser else {
            Logger.log("no target user set", event: .error)
            return
        }
        
        // Get all the teams for which the target user is associated with
        let teams: [TeamSnapshot] = self.teams.filter({ targetUser.teams.contains($0.guid) })
        
        // Compute the tasks for each of the teams in turn, added any found tasks to the result
        for team in teams {
            // FilteredUsers is the different clusters within the team
            let filteredUsers: [UserSnapshot] = self.users.filter({ $0.teams.contains(team.guid) })
            
            var filteredTasks: [TaskSnapshot] = []  // empty array to hold the tasks
            for user in filteredUsers {  // for each cluster point
                for tuid in user.tasks {  // for each task that is associated with that user
                    if let task = self.tasks.first(where: { $0.tuid == tuid }) {  // there should only be one task that matches the TUID
                        if task.status == "open" {  // only add the task if it is not already assigned (ie 'open')
                            filteredTasks.append(task)
                        }
                    }
                }
            }
            
            // TODO at this point, run any algorithm on the filteredUsers (clusters) and the tasks (targets)
            self.KMeansClustering(filteredUsers: filteredUsers, filteredTasks: filteredTasks)
        }
        
        callback(Array(Set(targetUser.tasks)))
    }
    
    private func KMeansClustering(filteredUsers: [UserSnapshot], filteredTasks: [TaskSnapshot]) {
        Logger.log("running KMeansClustering")
        let clusters: [Cluster] = filteredUsers.map({ Cluster(user: $0) })
        
        for task in filteredTasks {
            for cluster in clusters {
                let sim: Double = self.getSimilarity(task: task, cluster: cluster)
                cluster.table[task.id] = sim
                task.table[cluster.tag] = sim
            }
        }
        
        // Assignment round 1 -- if similarity meets threshold
        for cluster in clusters {
            for entry in cluster.table {
                if entry.value > 0.5 {  // add all the matches above 50%
                    cluster.addTask(filteredTasks.filter({ $0.id == entry.key }).first)
                }
            }
        }
        
        // Assignment round 2 -- if not already assigned, assign to best
        for task in filteredTasks {
            if task.assignmentCount == 0 {
                let keys = task.table.keys
                var currMax = (-1, -1.0)  // (key, value)
                for key in keys {
                    if task.table[key]! > currMax.1 {
                        currMax = (key, task.table[key]!)
                    }
                }
                
                if currMax.0 != -1 && clusters.contains(where: {$0.tag == currMax.0 }) {
                    clusters.filter({ $0.tag == currMax.0 }).first!.addTask(task)
                }
            }
        }
        
        // Assign the tasks back to the user
        for cluster in clusters {
            cluster.finalize()
        }
    }
    
    // TODO: This function needs an overhaul
    //       There should be a way to compare the similarity of words
    //       with one another that is fast and efficient.
    private func getSimilarity(task: TaskSnapshot, cluster: Cluster) -> Double {
        let taskKeywords = task.keywords
        let clusterKeywords = cluster.user.keywords
        
        for word in taskKeywords {
            if clusterKeywords.contains(word) { return 1.0 }  // currently returns 1 if exact match
        }
        
        return 0.0
    }
    
    public static func runRecommendationSystem(targetUUID: String, callback: @escaping ((_ tasks: [String]) -> Void)) {
        let rec = Recomendation(targetUUID: targetUUID)
        rec.setupCallback = { [rec, callback] in
            Logger.log("recommendation system initialized and setup")
            rec.generateKeywords { [rec, callback] in
                Logger.log("recommendation system keyword generation complete")
                rec.getPredictedTasks(callback: { [callback] (pred_tasks) in
                    Logger.log("recommendation system predictions complete")
                    Logger.log("found \(pred_tasks.count) task predictions:")
                    for t in pred_tasks { Logger.log("  " + t) }  // print info
                    callback(pred_tasks)
                })
            }
        }
    }
}

private class Cluster {
    public let user: UserSnapshot
    public let tag: Int
    public var currentTasks: [TaskSnapshot] = []
    public var table: [Int: Double] = [:]
    
    init(user: UserSnapshot) {
        self.user = user
        self.tag = Cluster.getTag()
    }
    
    public func addTask(_ task: TaskSnapshot?) {
        if let task = task {
            if !self.currentTasks.contains(where: { $0.tuid == task.tuid }) {
                task.assignmentCount += 1
                self.currentTasks.append(task)
            }
        }
    }
    
    public func removeTask(_ task: TaskSnapshot) {
        if let idx = self.currentTasks.index(where: { $0.tuid == task.tuid }) {
            self.currentTasks.remove(at: idx)
        }
    }
    
    public func finalize() {
        self.user.tasks = self.currentTasks.map({ $0.tuid })
    }
    
    // Static function to generate the cluster tag
    private static var currTagCounter = 0;
    private static func getTag() -> Int {
        Cluster.currTagCounter += 1
        return Cluster.currTagCounter - 1
    }
}

private class UserSnapshot {
    public let uuid: String
    public var keywords: [String]
    public var tasks: [String]
    public var teams: [String]
    public let id: Int
    
    init(uuid: String, tasks: [String], teams: [String]) {
        self.uuid = uuid
        self.keywords = []
        self.tasks = tasks
        self.teams = teams
        self.id = UserSnapshot.getID()
    }
    
    private static var idCounter = 0
    private static func getID() -> Int {
        UserSnapshot.idCounter += 1
        return UserSnapshot.idCounter - 1
    }
}

private class TaskSnapshot {
    public let tuid: String
    public let title: String
    public let description: String
    public let status: String
    public let id: Int
    public var keywords: [String] = []
    public var table: [Int: Double] = [:]
    public var assignmentCount = 0
    
    init(tuid: String, title: String, description: String, status: String) {
        self.tuid = tuid
        self.title = title
        self.description = description
        self.status = status
        self.id = TaskSnapshot.getID()
    }
    
    public func tokenize() -> [String] {
        return self.title.components(separatedBy: " ").map({$0.lowercased()})
    }
    
    private static var idCounter = 0
    private static func getID() -> Int {
        TaskSnapshot.idCounter += 1
        return TaskSnapshot.idCounter - 1
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
                    if let tasksDict = value["current_tasks"] as? NSDictionary {
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
