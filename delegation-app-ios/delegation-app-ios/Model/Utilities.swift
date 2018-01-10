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
        static let MINIMUM_PASSWORD_LENGTH: Int = 6
    }
    
    public class Team {
        static let DEFAULT_TEAMNAME: String = ""
        static let DEFAULT_OWNER: String = ""
        static let DEFAULT_DESCRIPTION: String = ""
    }
}

class Utilities {
    
    class Status {
        public let status: Bool
        public let message: String
        
        init(_ status: Bool, msg: String) {
            self.status = status
            self.message = msg
        }
        
        init(_ status: Bool) {
            self.status = status
            self.message = ""
        }
    }
    
//    static func isValidEmail(_ testStr: String) -> Bool {
//        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
//
//        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
//        return emailTest.evaluate(with: testStr)
//    }
    
    
    
    static func validateEmail(_ email: String) -> Status {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailTest.evaluate(with: email) {
            return Status(true)
        } else {
            return Status(false, msg: "Email must match the format: 'name@domain.com'")
        }
    }
    
    static func validatePassword(_ pswd: String) -> Status {
        if pswd == "" {
            return Status(false, msg: "Password is required.")
        }
        
        if pswd.count < Globals.User.MINIMUM_PASSWORD_LENGTH {
            return Status(false, msg: "Password length must be \(Globals.User.MINIMUM_PASSWORD_LENGTH) characters or longer.")
        }
        
        return Status(true)
    }
    
    static func validatePasswords(pswd: String, cnfrm: String) -> Status {
        let status = validatePassword(pswd)
        
        if !status.status {
            return status
        }
        
        if pswd != cnfrm {
            return Status(false, msg: "Passwords do not match.")
        }
        
        return status
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
    
    static func getUserInformation(uid: String, callback: @escaping ((_ user: User?, _ error: Error?) -> Void)) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("users/\(uid)/information").observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            callback(FirebaseUtilities.extractUserInformationFromSnapshot(snapshot, uuid: uid), nil)
            
        }) { (error) in
            print(error.localizedDescription)
            callback(nil, error)
        }
    }
    
    static func extractTeamInformationFromSnapshot(_ snapshot: DataSnapshot) -> Team {
        let value = snapshot.value as? NSDictionary
        
        let teamname = value?["teamname"] as? String ?? Globals.Team.DEFAULT_TEAMNAME
        let description = value?["description"] as? String ?? Globals.Team.DEFAULT_DESCRIPTION
        let owner = value?["owner"] as? String ?? Globals.Team.DEFAULT_OWNER
        
        return Team(teamname: teamname, description: description, owner: owner)
    }
    
    static func getTeamInformation(guid: String, callback: @escaping ((_ team: Team?, _ error: Error?) -> Void)) {
        var ref: DatabaseReference
        ref = Database.database().reference()
        
        ref.child("teams/\(guid)/information").observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            callback(FirebaseUtilities.extractTeamInformationFromSnapshot(snapshot), nil)
            
        }) { (error) in
            print(error.localizedDescription)
            callback(nil, error)
        }
    }
    
    static func getAllTeams(callback: @escaping ((_ teams: [Team]?, _ error: Error?) -> Void)) {
        let ref: DatabaseReference! = Database.database().reference()
        ref.child("teams").observeSingleEvent(of: .value, with: { (snapshot) in
            let teams = FirebaseUtilities.extractTeamsFromSnapshot(snapshot)
            callback(teams, nil)
        }) { (error) in
            print(error.localizedDescription)
            callback(nil, error)
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
    
    static func getTask(tuid: String, callback: @escaping ((_ task: Task?, _ error: Error?) -> Void)) {
        var ref: DatabaseReference
        ref = Database.database().reference()
        
        ref.child("tasks/\(tuid)").observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            callback(FirebaseUtilities.extractTaskFromSnapshot(snapshot), nil)
            
        }) { (error) in
            print(error.localizedDescription)
            callback(nil, error)
        }
    }
    
    static func createNewUser(newUser: User, selectedTeams: [String], callback: @escaping ((_ error: Error?) -> Void)) {
        Auth.auth().createUser(withEmail: newUser.getEmailAddress(), password: newUser.getPassword()) {
            (user, error) in
            
            if (user != nil && error == nil) {
                let uid = Auth.auth().currentUser!.uid
                print("Got new user UID: \(uid)")
                
                let ref = Database.database().reference(withPath: "users/\(uid)/information/")
                ref.child("firstname").setValue(newUser.getFirstName())
                ref.child("lastname").setValue(newUser.getLastName())
                ref.child("email").setValue(newUser.getEmailAddress())
                ref.child("phone").setValue(newUser.getPhoneNumber())
                
                let teamsRef = Database.database().reference(withPath: "users/\(uid)/teams/")
                for id in selectedTeams {
                    teamsRef.childByAutoId().setValue(id)
                }
                
                print("firebase: user added successfully")
                
                callback(nil)
            } else {
                print("firebase: failed to add user")
                print(String(describing:error?.localizedDescription))
                callback(error)
            }
        }
    }
    
    static func deleteCurrentUserAccount(callback: @escaping ((_ status: Int) -> Void)) {
        callback(500)
    }
    
    static func loginUser(username: String, password: String, callback: @escaping ((_ uuid: String?, _ error: Error?) -> Void)) {
        Auth.auth().signIn(withEmail: username, password: password) {
            (user, error) in
            if let user = user {
                callback(user.uid, nil)
            } else {
                print("Error found logging in user. \(error?.localizedDescription ?? "Unknown Error")")
                callback(nil, error)
            }
        }
    }
    
    static func performWelcomeProcedure(controller: UIViewController, username: String, password: String, callback: @escaping ((_ user: User?, _ tasks: [Task]?, _ error: Error?) -> Void)) {
        loginUser(username: username, password: password, callback: { (uuid, error) in
            if let uuid = uuid {
                if uuid != Globals.User.DEFAULT_UUID {
                    FirebaseUtilities.getUserInformation(uid: uuid, callback: { (user, error) in
                        if let user = user {
                            print("performWelcomeProcedure: successfully retrieved user information, returning user,nil,nil")
                            callback(user, nil, nil)
                        } else {
                            print("performWelcomeProcedure: unable to get user information, returning nil,nil,error")
                            print(String(describing: error?.localizedDescription))
                            callback(nil, nil, error)
                        }
                    })
                } else {
                    print("performWelcomeProcedure: Unable to fetch user without default uuid, returning nil,nil,error")
                    callback(nil, nil, error)
                }
            } else {
                print("performWelcomeProcedure: unable to fetch user, returning nil,nil")
                print(String(describing: error?.localizedDescription))
                callback(nil, nil, error)
            }
            
        })
    }
}
