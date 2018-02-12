//
//  User.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/10/17.
//  Copyright © 2017-2018 Erik Phillips. All rights reserved.
//

import Foundation
import Firebase

enum AccessRole: String {
    case none
    case owner
    case admin
    case manager
    case member
}

class User {
    private var teams : [Team]
    private var tasks : [Task]
    
    private var uuid: String
    private var firstname: String
    private var lastname: String
    private var emailAddress: String
    private var phoneNumber: String
    private var password: String?
    
    public var observers = FBObservers<User>()
    private var initialSetupComplete = false
    var userUpdatedHandler: (() -> Void)? {
        didSet {
            if self.initialSetupComplete {
                Logger.log("user updated, handler was called for \(self.toString())")
                userUpdatedHandler?()
            } else {
                Logger.log("user handler was called, but setup has not finished.. aborting", event: .warning)
            }
        }
    }
   
    
    init() {
        self.uuid = Globals.UserGlobals.DEFAULT_UUID
        self.firstname = Globals.UserGlobals.DEFAULT_FIRSTNAME
        self.lastname = Globals.UserGlobals.DEFAULT_LASTNAME
        self.emailAddress = Globals.UserGlobals.DEFAULT_EMAIL
        self.phoneNumber = Globals.UserGlobals.DEFAULT_PHONE
        self.tasks = Globals.UserGlobals.DEFAULT_TASKS
        self.teams = Globals.UserGlobals.DEFAULT_TEAMS
        
        Logger.log("non-observable user object created", event: .warning)
    }
    
    init(uuid: String) {
        self.uuid = uuid
        self.firstname = Globals.UserGlobals.DEFAULT_FIRSTNAME
        self.lastname = Globals.UserGlobals.DEFAULT_LASTNAME
        self.emailAddress = Globals.UserGlobals.DEFAULT_EMAIL
        self.phoneNumber = Globals.UserGlobals.DEFAULT_PHONE
        self.tasks = Globals.UserGlobals.DEFAULT_TASKS
        self.teams = Globals.UserGlobals.DEFAULT_TEAMS
        
        Logger.log("created new user, waiting on observable for 'user/\(uuid)/'")
        
        var ref: DatabaseReference!
        ref = Database.database().reference().child("users/\(uuid)/")
        
        ref.observe(DataEventType.value, with: {
            [weak self] (snapshot) in
            guard let this = self else { return }
            
            Logger.log("user update recieved from database for 'users/\(this.uuid)/", event: .verbose)
            
            let value = snapshot.value as? NSDictionary
            
            let information = value?["information"] as? NSDictionary
            this.firstname = information?["firstname"] as? String ?? this.firstname
            this.lastname = information?["lastname"] as? String ?? this.lastname
            this.emailAddress = information?["email"] as? String ?? this.emailAddress
            this.phoneNumber = information?["phone"] as? String ?? this.phoneNumber
            
            if let teams = value?["teams"] as? NSDictionary {
                Logger.log("teams information unwrapped for user observable")
//                var foundGUIDs: [String] = []
                
                this.teams = []
                for (_, value) in teams {
                    if let guid = value as? String {
                        this.teams.append(Team(guid: guid))
                        Logger.log("added a team, guid='\(guid)'")
                        
//                        foundGUIDs.append(guid)
//
//                        var addThisTeam = true
//                        for team in this.teams {
//                            if team.getGUID() == guid {
//                                addThisTeam = false
//                                break
//                            }
//                        }
//
//                        if addThisTeam {
//                            this.teams.append(Team(guid: guid))
//                            Logger.log("added a team, guid='\(guid)'")
//                        }
                    }
                }
                
//                for team in this.teams {
//                    if !foundGUIDs.contains(team.getGUID()) {
//                        if let idx = this.teams.index(where: {$0 === team}) {
//                            this.teams.remove(at: idx)
//                        }
//                    }
//                }
            } else {
                Logger.log("teams could not be unwrapped in user observable")
            }
            
            if let tasks = value?["current_tasks"] as? NSDictionary {
                Logger.log("task information unwrapped for user observable")
                this.tasks = []  // clear the array to start from beginning
                for (_, value) in tasks {
                    if let tuid = value as? String {
                        this.tasks.append(Task(uuid: this.uuid, tuid: tuid))
                        Logger.log("added a task, tuid=\(tuid)")
                    }
                }
            } else {
                Logger.log("tasks could not be unwrapped in user observable")
            }
            
            Logger.log("updated user information: \(this.toString())", event: .verbose)
            
            this.initialSetupComplete = true
            this.userUpdatedHandler?()  // called when the user has been updated at any point in the application
            this.observers.notify(this)
        })
    }
    
    init(uuid: String, firstname: String, lastname: String, phoneNumber: String, emailAddress: String) {
        self.uuid = uuid
        self.firstname = firstname
        self.lastname = lastname
        self.emailAddress = emailAddress
        self.phoneNumber = phoneNumber
        self.tasks = Globals.UserGlobals.DEFAULT_TASKS
        self.teams = Globals.UserGlobals.DEFAULT_TEAMS
        
        Logger.log("creating a new user information (non-observable), uuid='\(uuid)'")
        
        let ref = Database.database().reference(withPath: "users/\(self.uuid)/information")
        ref.child("firstname").setValue(firstname)
        ref.child("lastname").setValue(lastname)
        ref.child("phone").setValue(phoneNumber)
        ref.child("email").setValue(emailAddress)
        self.observers.notify(self)
    }
    
    func getUUID() -> String {
        return self.uuid
    }
    
    func getTeams() -> [Team] {
        return self.teams
    }
    
    func getTasks() -> [Task] {
        return self.tasks
    }
    
    func getFullName() -> String {
        return String(self.firstname + " " + self.lastname)
    }
    
    func getFirstName() -> String {
        return self.firstname
    }
    
    func getLastName() -> String {
        return self.lastname
    }
    
    func getEmailAddress() -> String {
        return self.emailAddress
    }
    
    func getPhoneNumber() -> String {
        return Utilities.format(phoneNumber: self.phoneNumber) ?? Globals.UserGlobals.DEFAULT_PHONE
    }
    
    func getPassword() -> String {
        if let password = self.password {
            return password
        } else {
            return ""
        }
    }
    
    func addNewTeam(guid: String) {
        Logger.log("adding team '\(guid)' to user '\(self.uuid)'")
        let ref = Database.database().reference(withPath: "users/\(self.uuid)/teams/")
        ref.childByAutoId().setValue(guid)
        
        let teamRef = Database.database().reference(withPath: "teams/\(guid)/members/")
        teamRef.childByAutoId().setValue(self.uuid)
        
        self.teams.append(Team(guid: guid))
    }
    
    func updateCurrentUser(firstname: String?, lastname: String?, email: String?, phone: String?, password: String?) {
        if self.uuid != Globals.UserGlobals.DEFAULT_UUID {
            Logger.log("updating user information in database", event: .verbose)
            
            let ref = Database.database().reference(withPath: "users/\(self.uuid)/information")
            
            if let firstname = firstname {
                self.firstname = firstname
                ref.child("firstname").setValue(firstname)
            }
            
            if let lastname = lastname {
                self.lastname = lastname
                ref.child("lastname").setValue(lastname)
            }
            
            if let phone = phone {
                self.phoneNumber = phone
                ref.child("phone").setValue(phone)
            }
            
            if let email = email {
                self.emailAddress = email
                Auth.auth().currentUser?.updateEmail(to: email) { (error) in
                    if let error = error {
                        Logger.log("unable to update email address - \(error.localizedDescription)", event: .error)
                    } else {
                        Logger.log("Email address updated successfully: \(email).")
                    }
                }
            }
            
            if let password = password {
                // CAUTION: the password is not stored in the user object, so if it is changed, it better be recorded
                Auth.auth().currentUser?.updatePassword(to: password) { (error) in
                    if let error = error {
                        Logger.log("Error: Unable to update password - \(error.localizedDescription)", event: .error)
                    } else {
                        Logger.log("Password updated successfully: \(password).", event: .warning)
                    }
                }
            }
            
            // Notify all observers that data has changed for this object
            self.observers.notify(self)
            
        } else {
            Logger.log("unable to update user information in database - no uuid other than default", event: .error)
        }
    }
    
    func toString() -> String {
        return "User: uuid=\"" + self.uuid + "\", first=\"" + self.firstname + "\", last=\"" + self.lastname + "\"; email=\"" + self.emailAddress + "\", phone=\"" + self.phoneNumber + "\";"
    }
}

class UserAIKeyword {
    private var key : String
    private var value : Int
    
    init(key: String, value: Int) {
        self.key = key
        self.value = value
    }
}

class UserAI {
    private var keywords : [UserAIKeyword]
    
    init() {
        self.keywords = []
    }
}
