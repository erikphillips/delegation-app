//
//  Utilities.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/20/17.
//  Copyright © 2017-2018  Erik Phillips. All rights reserved.
//

import Foundation
import Firebase

class Globals {
    public class Task {
        static let DEFAULT_TITLE: String = ""
        static let DEFAULT_PRIORITY: String = "5"
        static let DEFAULT_DESCRIPTION: String = ""
        static let DEFAULT_TEAM: String = ""
        static let DEFAULT_STATUS: String = ""
        static let DEFAULT_RESOLUTION: String = ""
        static let DEFAULT_ASSIGNEE: String = ""
    }
    
    public class User {
        static let DEFAULT_FIRSTNAME: String = ""
        static let DEFAULT_LASTNAME: String = ""
        static let DEFAULT_EMAIL: String = ""
        static let DEFAULT_PHONE: String = ""
        static let DEFAULT_UUID: String = ""
    }
    
    public class Team {
        static let DEFAULT_TEAMNAME: String = ""
        static let DEFAULT_OWNER: String = ""
        static let DEFAULT_DESCRIPTION: String = ""
    }
}

class Utilities {
    
    static func isValidEmail(_ testStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    static func isValidPassword(_ testStr: String) -> Bool {
        return testStr.count > 5
    }
    
    static func isValidPasswords(pswd: String, cnfrm: String) -> Bool {
        return pswd.count > 5 && pswd == cnfrm
    }
}

class FirebaseUtilities {
    static func extractTeamsFromSnapshot(_ snapshot: DataSnapshot) -> [Team] {
        print("Extracting teams...")
        
        var teams: [Team] = []
        
        if let value = (snapshot.value as? NSDictionary) {
            for elem in value {
                if let teamData = elem.value as? NSDictionary {
                    let teamname = teamData["teamname"] as? String ?? ""
                    let uid = elem.key as? String ?? ""
                    teams.append(Team(teamname: teamname, uid: uid))
                }
            }
        }
        
        print("Found \(teams.count) teams")
        
        return teams
    }
    
    static func extractUserInformationFromSnapshot(_ snapshot: DataSnapshot) -> User {
        let value = snapshot.value as? NSDictionary
        
        let firstname = value?["firstname"] as? String ?? Globals.User.DEFAULT_FIRSTNAME
        let lastname = value?["lastname"] as? String ?? Globals.User.DEFAULT_LASTNAME
        let email = value?["email"] as? String ?? Globals.User.DEFAULT_EMAIL
        let phone = value?["phone"] as? String ?? Globals.User.DEFAULT_PHONE
        let uuid = Globals.User.DEFAULT_UUID
        
        return User(uid: uuid, firstname: firstname, lastname: lastname, email: email, phone: phone)
    }
    
    static func extractUserInformationFromSnapshot(_ snapshot: DataSnapshot, uuid: String) -> User {
        let value = snapshot.value as? NSDictionary
        
        let firstname = value?["firstname"] as? String ?? Globals.User.DEFAULT_FIRSTNAME
        let lastname = value?["lastname"] as? String ?? Globals.User.DEFAULT_LASTNAME
        let email = value?["email"] as? String ?? Globals.User.DEFAULT_EMAIL
        let phone = value?["phone"] as? String ?? Globals.User.DEFAULT_PHONE
        
        return User(uid: uuid, firstname: firstname, lastname: lastname, email: email, phone: phone)
    }
    
    static func getUserInformation(uid: String, callback: @escaping ((_ user: User) -> Void)) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("users/\(uid)/information").observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            callback(FirebaseUtilities.extractUserInformationFromSnapshot(snapshot, uuid: uid))
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    static func extractTeamInformationFromSnapshot(_ snapshot: DataSnapshot) -> Team {
        let value = snapshot.value as? NSDictionary
        
        let teamname = value?["teamname"] as? String ?? Globals.Team.DEFAULT_TEAMNAME
        let description = value?["description"] as? String ?? Globals.Team.DEFAULT_DESCRIPTION
        let owner = value?["owner"] as? String ?? Globals.Team.DEFAULT_OWNER
        
        return Team(teamname: teamname, description: description, owner: owner)
    }
    
    static func getTeamInformation(guid: String, callback: @escaping ((_ team: Team) -> Void)) {
        var ref: DatabaseReference
        ref = Database.database().reference()
        
        ref.child("teams/\(guid)/information").observeSingleEvent(of: .value, with: {
            (snapshot) in
            callback(FirebaseUtilities.extractTeamInformationFromSnapshot(snapshot))
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    static func extractTaskFromSnapshot(_ snapshot: DataSnapshot) -> Task {
        let value = snapshot.value as? NSDictionary
        
        let title = value?["title"] as? String ?? Globals.Task.DEFAULT_TITLE
        let priority = value?["priority"] as? String ?? Globals.Task.DEFAULT_PRIORITY
        let description = value?["description"] as? String ?? Globals.Task.DEFAULT_DESCRIPTION
        let team = value?["team"] as? String ?? Globals.Task.DEFAULT_TEAM
        let status = value?["status"] as? String ?? Globals.Task.DEFAULT_STATUS
        let resolution = value?["resolution"] as? String ?? Globals.Task.DEFAULT_RESOLUTION
        let assignee = value?["assignee"] as? String ?? Globals.Task.DEFAULT_ASSIGNEE
        
        return Task(title: title, priority: priority, description: description, team: team, status: status, resolution: resolution, assignee: assignee)
    }
    
    static func getTask(tuid: String, callback: @escaping ((_ task: Task) -> Void)) {
        var ref: DatabaseReference
        ref = Database.database().reference()
        
        ref.child("tasks/\(tuid)").observeSingleEvent(of: .value, with: {
            (snapshot) in
            callback(FirebaseUtilities.extractTaskFromSnapshot(snapshot))
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    static func deleteCurrentUserAccount(callback: @escaping ((_ status: Int) -> Void)) {
        callback(500)
    }
    
    static func performWelcomeProcedure(controller: UIViewController, username: String, password: String, callback: @escaping ((_ user: User, _ tasks: [Task]) -> Void)) {
        
    }
}
