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
    
    public class Application {
        static let VERSION: String = "v0.1"
    }
}

class Utilities {
    
    static func validateEmail(_ email: String) -> Status {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailTest.evaluate(with: email) {
            return Status(true)
        } else {
            return Status(false, "Email must match the format: 'name@domain.com'")
        }
    }
    
    static func validatePassword(_ pswd: String) -> Status {
        if pswd == "" {
            return Status(false, "Password is required.")
        }
        
        if pswd.count < Globals.User.MINIMUM_PASSWORD_LENGTH {
            return Status(false, "Password length must be \(Globals.User.MINIMUM_PASSWORD_LENGTH) characters or longer.")
        }
        
        return Status(true)
    }
    
    static func validatePasswords(pswd: String, cnfrm: String) -> Status {
        let status = validatePassword(pswd)
        
        if !status.status {
            return status
        }
        
        if pswd != cnfrm {
            return Status(false, "Passwords do not match.")
        }
        
        return status
    }
    
    static func validateUser(_ user: User?) -> Status {
        if let user = user {
            if user.getFirstName() == Globals.User.DEFAULT_FIRSTNAME {
                return Status(false, "User object is missing a valid first name.")
            } else if user.getLastName() == Globals.User.DEFAULT_LASTNAME {
                return Status(false, "User object is missing a valid last name.")
            } else if user.getEmailAddress() == Globals.User.DEFAULT_EMAIL {
                return Status(false, "User object is missing a valid email address.")
            } else {
                return Status(true, "User object is considered valid (first/last name and email address.")
            }
        } else {
            return Status(false, "User object is an optional set as nil.")
        }
    }
    
    static func validateTask(_ task: Task?) -> Status {
        if let task = task {
            if task.getTitle() == Globals.Task.DEFAULT_TITLE {
                return Status(false, "Task object is missing a valid title")
            } else if task.getDescription() == Globals.Task.DEFAULT_DESCRIPTION {
                return Status(false, "Task object is missing a valid description")
            } else if task.getAssignee() == Globals.Task.DEFAULT_ASSIGNEE {
                return Status(false, "Task object is missing a valid assignee")
            } else if task.getTeamUID() == Globals.Task.DEFAULT_TEAM {
                return Status(false, "Task object is missing a valid team")
            } else {
                return Status(true, "Task object is considered valid (title, description, assignee, and team")
            }
        } else {
            return Status(false, "Task object is an optional set as nil")
        }
    }
    
    static func validateTeam(_ team: Team?) -> Status {
        if let team = team {
            if team.getTeamName() == Globals.Team.DEFAULT_TEAMNAME {
                return Status(false, "Team object is missing a valid teamname")
            } else if team.getDescription() == Globals.Team.DEFAULT_DESCRIPTION {
                return Status(false, "Team object is missing a valid description")
            } else if team.getOwnerUUID() == Globals.Team.DEFAULT_OWNER {
                return Status(false, "Team object is missing a valid owner")
            } else {
                return Status(true, "Team ibject is considered valid (teamname, description, owner)")
            }
        } else {
            return Status(false, "Team object is an optional set as nil")
        }
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
    
    static func getUserInformation(uid: String, callback: @escaping ((_ user: User?, _ status: Status) -> Void)) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        ref.child("users/\(uid)/information").observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            let user = FirebaseUtilities.extractUserInformationFromSnapshot(snapshot, uuid: uid)
            let userStatus = Utilities.validateUser(user)
            if userStatus.status {
                callback(user, userStatus)
            } else {
                callback(nil, userStatus)
            }
        }) { (error) in
            print(error.localizedDescription)
            callback(nil, Status(false, error.localizedDescription))
        }
    }
    
    static func extractTeamInformationFromSnapshot(_ snapshot: DataSnapshot) -> Team {
        let value = snapshot.value as? NSDictionary
        
        let teamname = value?["teamname"] as? String ?? Globals.Team.DEFAULT_TEAMNAME
        let description = value?["description"] as? String ?? Globals.Team.DEFAULT_DESCRIPTION
        let owner = value?["owner"] as? String ?? Globals.Team.DEFAULT_OWNER
        
        return Team(teamname: teamname, description: description, owner: owner)
    }
    
    static func getTeamInformation(guid: String, callback: @escaping ((_ team: Team?, _ status: Status) -> Void)) {
        var ref: DatabaseReference
        ref = Database.database().reference()
        
        ref.child("teams/\(guid)/information").observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            callback(FirebaseUtilities.extractTeamInformationFromSnapshot(snapshot), Status(true))
            
        }) { (error) in
            print(error.localizedDescription)
            callback(nil, Status(false, error.localizedDescription))
        }
    }
    
    static func getAllTeams(callback: @escaping ((_ teams: [Team]?, _ status: Status) -> Void)) {
        let ref: DatabaseReference! = Database.database().reference()
        ref.child("teams").observeSingleEvent(of: .value, with: { (snapshot) in
            let teams = FirebaseUtilities.extractTeamsFromSnapshot(snapshot)
            callback(teams, Status(true))
        }) { (error) in
            print(error.localizedDescription)
            callback(nil, Status(false, error.localizedDescription))
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
    
    static func getTask(tuid: String, callback: @escaping ((_ task: Task?, _ status: Status) -> Void)) {
        var ref: DatabaseReference
        ref = Database.database().reference()
        
        ref.child("tasks/\(tuid)").observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            callback(FirebaseUtilities.extractTaskFromSnapshot(snapshot), Status(true))
            
        }) { (error) in
            print(error.localizedDescription)
            callback(nil, Status(false, error.localizedDescription))
        }
    }
    
    static func createTask(_ task: Task) {
        var ref: DatabaseReference
        ref = Database.database().reference(withPath: "tasks").childByAutoId()
        
        ref.child("title").setValue(task.getTitle())
        ref.child("priority").setValue(task.getPriority())
        ref.child("description").setValue(task.getDescription())
        ref.child("team").setValue(task.getTeamUID())
        ref.child("status").setValue(task.getStatus())
        ref.child("resolution").setValue(task.getResolution())
        ref.child("assignee").setValue(task.getAssignee())
    }
    
    static func getCurrentTaskIDs(uuid: String, callback: @escaping ((_ taskIDs: [String]?, _ status: Status) -> Void)) {
        var ref: DatabaseReference
        ref = Database.database().reference()
        
        print("Attempting to read: 'users/\(uuid)/current_tasks'...")
        ref.child("users/\(uuid)/current_tasks").observeSingleEvent(of: .value, with: { (snapshot) in
            if let values = snapshot.value as? NSDictionary {
                var ids: [String] = []
                for (key, value) in values {
                    if let value = value as? String {
                        ids.append(value)
                    } else {
                        print("Unable to get value from key=\((key as? String) ?? "") as string")
                    }
                }
                
                callback(ids, Status(true))
            } else {
                print("getCurrentTaskIDs: warning, unable to get value as NSDictionary")
                callback(nil, Status(false, "unable to retrieve task ids as an NSDictionary."))
            }
        })
    }
    
    static func updateCurrentUserEmailAddress(_ email: String, callback: @escaping ((_ status: Status) -> Void)) {
        let emailStatus = Utilities.validateEmail(email)
        if emailStatus.status {
            Auth.auth().currentUser?.updateEmail(to: email) { (error) in
                if let error = error {
                    print("Error: Unable to update email address - \(error.localizedDescription)")
                    callback(Status(false, error.localizedDescription))
                } else {
                    print("Email address updated successfully.")
                    callback(Status(true))
                }
            }
        } else {
            callback(emailStatus)
        }
    }
    
    static func updateCurrentUserPassword(_ password: String, callback: @escaping ((_ status: Status) -> Void)) {
        let passwordStatus = Utilities.validatePassword(password)
        if passwordStatus.status {
            Auth.auth().currentUser?.updatePassword(to: password) { (error) in
                if let error = error {
                    print("Error: Unable to update password - \(error.localizedDescription)")
                    callback(Status(false, error.localizedDescription))
                } else {
                    print("Password updated successfully.")
                    callback(Status(true))
                }
            }
        } else {
            callback(passwordStatus)
        }
    }
    
    static func updateCurrentUser(user: User, callback: @escaping ((_ status: Status) -> Void)) {
        var ref: DatabaseReference
        ref = Database.database().reference()
        
        ref.child("users/\(user.getUUID())/information").observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            let ref = Database.database().reference(withPath: "users/\(user.getUUID())/information")
            ref.child("firstname").setValue(user.getFirstName())
            ref.child("lastname").setValue(user.getLastName())
            ref.child("phone").setValue(user.getPhoneNumber())
            ref.child("email").setValue(user.getEmailAddress())
            
        }) { (error) in
            print(error.localizedDescription)
            callback(Status(false, error.localizedDescription))
        }
    }
    
    static func createNewUser(newUser: User, selectedTeams: [String], callback: @escaping ((_ status: Status) -> Void)) {
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
                
                callback(Status(true))
            } else {
                print("firebase: failed to add user")
                print(String(describing:error?.localizedDescription))
                callback(Status(false, error?.localizedDescription ?? "Unknown error"))
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
    
    static func performWelcomeProcedure(controller: UIViewController, username: String, password: String, callback: @escaping ((_ user: User?, _ tasks: [Task]?, _ status: Status) -> Void)) {
        loginUser(username: username, password: password, callback: { (uuid, error) in
            if let uuid = uuid {
                if uuid != Globals.User.DEFAULT_UUID {
                    var welcome_user: User? = nil
                    var welcome_tasks: [Task]? = nil
                    
                    let dispatchGroup = DispatchGroup()
                    
                    dispatchGroup.enter()
                    FirebaseUtilities.getUserInformation(uid: uuid, callback: { (user, status) in
                        if let user = user {
                            print("performWelcomeProcedure: successfully retrieved user information")
                            welcome_user = user
                        } else {
                            print("performWelcomeProcedure: unable to get user information")
                            print(status.message)
                        }
                        
                        dispatchGroup.leave()
                    })
                    
                    dispatchGroup.enter()
                    FirebaseUtilities.getCurrentTaskIDs(uuid: uuid, callback: { (taskIDs, status) in
                        if status.status {
                            if let taskIDs = taskIDs {
                                welcome_tasks = []
                                
                                print("Found the following task ids for the current user:")
                                for id in taskIDs {
                                    print(id)
                                    
                                    dispatchGroup.enter()
                                    FirebaseUtilities.getTask(tuid: id, callback: {
                                        (task, status) in
                                        if status.status {
                                            if let task = task {
                                                welcome_tasks?.append(task)
                                            }
                                        }
                                        dispatchGroup.leave()
                                    })
                                }
                            } else {
                                print("unable to unwrap the task ids")
                            }
                        } else {
                            print(status.message)
                        }
                        
                        dispatchGroup.leave()
                    })
                    
                    dispatchGroup.notify(queue: .main) {
                        print("Both dispatch functions complete 👍")
                        if let user = welcome_user {
                            if let tasks = welcome_tasks {
                                callback(user, tasks, Status(true))
                            } else {
                                callback(user, nil, Status(false, "Unable to read tasks array after dispatch finished."))
                            }
                        } else {
                            callback(nil, nil, Status(false, "Unable to read user after dispatch finished."))
                        }
                    }
                    
                    
                } else {
                    print("performWelcomeProcedure: Unable to fetch user without default uuid, returning nil,nil,error")
                    callback(nil, nil, Status(false, "Unable to fetch user without default uuid."))
                }
            } else {
                print("performWelcomeProcedure: unable to fetch user, returning nil,nil,false")
                print(String(describing: error?.localizedDescription))
                callback(nil, nil, Status(false, "Unable to fetch user. " + (error?.localizedDescription ?? "")))
            }
            
        })
    }
}
