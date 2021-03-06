//
//  User.swift
//  DelegationApp
//
//  Created by Erik Phillips on 12/10/17.
//  Copyright © 2017-2018 Erik Phillips. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase

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
    private var predictedTasks : [Task]
    
    private var uuid: String
    private var firstname: String
    private var lastname: String
    private var emailAddress: String
    private var phoneNumber: String
    private var password: String?
    
    public var observers = FBObservers<User>()
    
    private var setupComplete = false
    var setupCallback: (() -> Void)? {
        didSet {
            if setupComplete {
                setupCallback?()
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
        self.predictedTasks = Globals.UserGlobals.DEFAULT_TASKS
        
        Logger.log("non-observable user object created", event: .warning)
        
        if !self.setupComplete {
            self.setupComplete = true
            self.setupCallback?()
        }
        
        self.observers.notify(self)
    }
    
    init(uuid: String) {
        self.uuid = uuid
        self.firstname = Globals.UserGlobals.DEFAULT_FIRSTNAME
        self.lastname = Globals.UserGlobals.DEFAULT_LASTNAME
        self.emailAddress = Globals.UserGlobals.DEFAULT_EMAIL
        self.phoneNumber = Globals.UserGlobals.DEFAULT_PHONE
        self.tasks = Globals.UserGlobals.DEFAULT_TASKS
        self.teams = Globals.UserGlobals.DEFAULT_TEAMS
        self.predictedTasks = Globals.UserGlobals.DEFAULT_TASKS
        
        self.observeTeams()
        self.observeTasks()
        
        Logger.log("created new user, waiting on observable for 'user/\(uuid)/information'")
        
        let ref = Database.database().reference().child("users/\(uuid)/information")
        ref.observe(DataEventType.value, with: {
            [weak self] (snapshot) in
            guard let this = self else { return }
            
            Logger.log("user update recieved from database for 'users/\(this.uuid)/information", event: .verbose)
            
            let information = snapshot.value as? NSDictionary
            this.firstname = information?["firstname"] as? String ?? this.firstname
            this.lastname = information?["lastname"] as? String ?? this.lastname
            this.emailAddress = information?["email"] as? String ?? this.emailAddress
            this.phoneNumber = information?["phone"] as? String ?? this.phoneNumber
            
            Logger.log("updated user information: \(this.toString())", event: .verbose)
            
            if !this.setupComplete {
                this.setupComplete = true
                this.setupCallback?()
            }
            
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
        self.predictedTasks = Globals.UserGlobals.DEFAULT_TASKS
        
        Logger.log("creating a new user information (non-observable), uuid='\(uuid)'")
        
        let ref = Database.database().reference(withPath: "users/\(self.uuid)/information")
        ref.child("firstname").setValue(firstname)
        ref.child("lastname").setValue(lastname)
        ref.child("phone").setValue(phoneNumber)
        ref.child("email").setValue(emailAddress)
        
        if !self.setupComplete {
            self.setupComplete = true
            self.setupCallback?()
        }
        
        self.observers.notify(self)
    }
    
    func observeTeams() {
        let ref = Database.database().reference(withPath: "users/\(uuid)/teams")
        ref.observe(.childAdded, with: {
            [weak self] (snapshot) in
            guard let this = self else { return }
            
            if let guid = snapshot.value as? String {
                Logger.log("adding new observable team guid=\"\(guid)\"")
                this.teams.append(Team(guid: guid))
                this.observers.notify(this)
            }
        })
        
        ref.observe(.childRemoved, with: {
            [weak self] (snapshot) in
            guard let this = self else { return }
            
            if let guid = snapshot.value as? String {
                for (idx, team) in this.teams.enumerated() {
                    if team.getGUID() == guid {
                        Logger.log("removing team idx=\(idx), guid=\"\(guid)\"")
                        this.teams.remove(at: idx)
                        break
                    }
                }
                
                this.observers.notify(this)
            }
        })
    }
    
    func observeTasks() {
        let ref = Database.database().reference(withPath: "users/\(uuid)/current_tasks")
        ref.observe(.childAdded, with: {
            [weak self] (snapshot) in
            guard let this = self else { return }
            
            if let tuid = snapshot.value as? String {
                Logger.log("adding new observable task tuid=\"\(tuid)\"")
                this.tasks.append(Task(tuid: tuid))
                this.observers.notify(this)
            }
        })
        
        ref.observe(.childRemoved, with: {
            [weak self] (snapshot) in
            guard let this = self else { return }
            
            if let tuid = snapshot.value as? String {
                for (idx, task) in this.tasks.enumerated() {
                    if task.getTUID() == tuid {
                        Logger.log("removing task idx=\(idx), guid=\"\(tuid)\"")
                        this.tasks.remove(at: idx)
                        break
                    }
                }
                
                this.observers.notify(this)
            }
        })
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
    
    func getRecommendedTasks() -> [Task] {
        return self.predictedTasks
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
        let ref = Database.database().reference(withPath: "users/\(self.uuid)/teams/\(guid)")
        ref.setValue(guid)
        
        let teamRef = Database.database().reference(withPath: "teams/\(guid)/members/")
        teamRef.child(self.uuid).setValue(self.uuid)
    }
    
    func leaveTeam(guid: String) {
        Logger.log("user leaving team '\(guid)'")
        
        let ref = Database.database().reference(withPath: "users/\(self.uuid)/teams/")
        ref.child("\(guid)").setValue(nil)
        
        let teamRef = Database.database().reference(withPath: "teams/\(guid)/members/")
        teamRef.child("\(self.uuid)").setValue(nil)
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
    
    func runPredictionAlgorithm(callback: @escaping ((_ tasks: [Task]) -> Void)) {
        Recommendation.runRecommendationSystem(targetUUID: self.uuid, callback: {
            [callback, weak self] (taskTUIDs) in
            guard let this = self else { return }
            
            var tasks: [Task] = []
            for tuid in taskTUIDs {
                tasks.append(Task(tuid: tuid))
            }
            
            this.predictedTasks = tasks;
            callback(tasks)
        })
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
