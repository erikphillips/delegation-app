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

//    init(uid: String, firstname: String, lastname: String, email: String, phone: String) {
//        self.uuid = uid
//        self.firstname = firstname
//        self.lastname = lastname
//        self.emailAddress = email
//        self.phoneNumber = phone
//        self.password = nil
//
//        self.teams = []
//        self.tasks = []
//
//        print("Created new user instance: \(self.firstname), \(self.lastname), \(self.emailAddress), \(self.phoneNumber)")
//    }
//
//    init(uid: String, firstname: String, lastname: String, email: String, phone: String, password: String) {
//        self.uuid = uid
//        self.firstname = firstname
//        self.lastname = lastname
//        self.emailAddress = email
//        self.phoneNumber = phone
//        self.password = password
//
//        self.teams = []
//        self.tasks = []
//
//        print("Created new user instance (with password): \(self.firstname), \(self.lastname), \(self.emailAddress), \(self.phoneNumber)")
//    }
//
//    init(uid: String, snapshot: DataSnapshot) {
//        let value = snapshot.value as? NSDictionary
//
//        self.uuid = uid
//        self.firstname = value?["firstname"] as? String ?? ""
//        self.lastname = value?["lastname"] as? String ?? ""
//        self.emailAddress = value?["email"] as? String ?? ""
//        self.phoneNumber = value?["phone"] as? String ?? ""
//        self.teams = []
//        self.tasks = []
//
//        let ref: DatabaseReference!
//        ref = Database.database().reference().child("users/\(uid)")
//        let _ = ref.observe(DataEventType.value, with: {
//            [weak self] (snapshot) in
//            guard let this = self else { return }
//
//            print("User information update detected...")
//            print(snapshot)
//            let value = snapshot.value as? NSDictionary
//
//            this.firstname = value?["firstname"] as? String ?? this.firstname
//            this.lastname = value?["lastname"] as? String ?? this.lastname
//            this.emailAddress = value?["email"] as? String ?? this.emailAddress
//            this.phoneNumber = value?["phone"] as? String ?? this.phoneNumber
//        })
//    }
    
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
        
        Logger.log("created new user, waiting on observable for 'user/\(uuid)/information/'")
        
        var ref: DatabaseReference!
        ref = Database.database().reference().child("users/\(uuid)/information/")
        
        ref.observe(DataEventType.value, with: {
            [weak self] (snapshot) in
            guard let this = self else { return }
            
            Logger.log("user update recieved from database for 'users/\(this.uuid)/information/", event: .verbose)
            
            let value = snapshot.value as? NSDictionary
            this.firstname = value?["firstname"] as? String ?? "error"
            this.lastname = value?["lastname"] as? String ?? this.lastname
            this.emailAddress = value?["email"] as? String ?? this.emailAddress
            this.phoneNumber = value?["phone"] as? String ?? this.phoneNumber
            
            Logger.log("updated user information: \(this.toString())", event: .verbose)
            
            this.initialSetupComplete = true
            this.userUpdatedHandler?()  // called when the user has been updated at any point in the application
            this.observers.notify(this)
        })
    }
    
    init(firstname: String, lastname: String, phoneNumber: String, emailAddress: String, password: String, callback: @escaping ((_ user: User, _ status: Status) -> Void)) {
        self.uuid = Globals.UserGlobals.DEFAULT_UUID
        self.firstname = firstname
        self.lastname = lastname
        self.emailAddress = emailAddress
        self.phoneNumber = phoneNumber
        self.tasks = Globals.UserGlobals.DEFAULT_TASKS
        self.teams = Globals.UserGlobals.DEFAULT_TEAMS
        
        Logger.log("creating a new user account, waiting on observable for '\(emailAddress)'")
        
        Auth.auth().createUser(withEmail: emailAddress, password: password, completion: {
            [weak self] (user, error) in
            guard let this = self else {
                Logger.log("Error", event: .error)
                return
            }
            
            if let user = user {
//                this.uuid = user.uid
                Logger.log("Recieved uuid='\(user.uid)' for the new user account")
                
                let ref = Database.database().reference(withPath: "users/\(this.uuid)/information")
                ref.child("firstname").setValue(this.firstname)
                ref.child("lastname").setValue(this.lastname)
                ref.child("email").setValue(this.emailAddress)
                ref.child("phone").setValue(this.phoneNumber)
                
                callback(this, Status(true))
            } else {
                Logger.log("firebase failed to add user:", event: .error)
                Logger.log(error?.localizedDescription ?? "unknown error", event: .error)
                callback(this, Status(false, error?.localizedDescription ?? "Unknown Error"))
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
    
    func getPassword() -> String {
        if let password = self.password {
            return password
        } else {
            return ""
        }
    }
    
    func addNewTeam(teamname: String) {
        let ref = Database.database().reference(withPath: "users/\(teamname)/teams/")
        ref.childByAutoId().setValue(teamname)
        
        self.teams.append(Team(guid: teamname))
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
