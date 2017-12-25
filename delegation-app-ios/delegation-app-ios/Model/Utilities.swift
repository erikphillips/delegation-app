//
//  Utilities.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/20/17.
//  Copyright © 2017 Erik Phillips. All rights reserved.
//

import Foundation
import Firebase

class Globals {
    static let DEFAULT_PRIORITY = 5
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
        
        let firstname = value?["firstname"] as? String ?? ""
        let lastname = value?["lastname"] as? String ?? ""
        let email = value?["email"] as? String ?? ""
        let phone = value?["phone"] as? String ?? ""
        
        return User(uid: "", firstname: firstname, lastname: lastname, email: email, phone: phone)
    }
    
    static func getUserInformation(uid: String, callback: @escaping ((_ user: User) -> Void)) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("users/\(uid)/information").observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            callback(FirebaseUtilities.extractUserInformationFromSnapshot(snapshot))
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    static func extractTeamInformationFromSnapshot(_ snapshot: DataSnapshot) -> Team {
        let value = snapshot.value as? NSDictionary
        
        let teamname = value?["teamname"] as? String ?? ""
        let description = value?["description"] as? String ?? ""
        let owner = value?["owner"] as? String ?? ""
        
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
        
        let taskname = value?["taskname"] as? String ?? ""
        // let summary = value?["summary"] as? String ?? ""
        let priority = value?["priority"] as? Int ?? Globals.DEFAULT_PRIORITY
        let description = value?["description"] as? String ?? ""
        let team = value?["team"] as? String ?? ""
        let state = value?["state"] as? String ?? "open"
        
        return Task(name: taskname, teamID: team, priority: priority, description: description, state: state)
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
}
