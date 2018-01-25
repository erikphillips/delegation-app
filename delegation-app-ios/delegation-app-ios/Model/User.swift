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

    init(uid: String, firstname: String, lastname: String, email: String, phone: String) {
        self.uuid = uid
        self.firstname = firstname
        self.lastname = lastname
        self.emailAddress = email
        self.phoneNumber = phone
        self.password = nil
        
        self.teams = []
        self.tasks = []
        
        print("Created new user instance: \(self.firstname), \(self.lastname), \(self.emailAddress), \(self.phoneNumber)")
    }
    
    init(uid: String, firstname: String, lastname: String, email: String, phone: String, password: String) {
        self.uuid = uid
        self.firstname = firstname
        self.lastname = lastname
        self.emailAddress = email
        self.phoneNumber = phone
        self.password = password
        
        self.teams = []
        self.tasks = []
        
        print("Created new user instance (with password): \(self.firstname), \(self.lastname), \(self.emailAddress), \(self.phoneNumber)")
    }
    
    init(uid: String, snapshot: DataSnapshot) {
        let value = snapshot.value as? NSDictionary
        
        self.uuid = uid
        self.firstname = value?["firstname"] as? String ?? ""
        self.lastname = value?["lastname"] as? String ?? ""
        self.emailAddress = value?["email"] as? String ?? ""
        self.phoneNumber = value?["phone"] as? String ?? ""
        self.teams = []
        self.tasks = []
        
        let ref: DatabaseReference!
        ref = Database.database().reference().child("users/\(uid)")
        let _ = ref.observe(DataEventType.value, with: {
            [weak self] (snapshot) in
            guard let this = self else { return }
            
            print("User information update detected...")
            print(snapshot)
            let value = snapshot.value as? NSDictionary
            
            this.firstname = value?["firstname"] as? String ?? this.firstname
            this.lastname = value?["lastname"] as? String ?? this.lastname
            this.emailAddress = value?["email"] as? String ?? this.emailAddress
            this.phoneNumber = value?["phone"] as? String ?? this.phoneNumber
        })
    }
    
    func getUUID() -> String {
        return self.uuid
    }
    
    func getTeams() -> [Team] {
        return self.teams
    }
    
//    func setTeams(_ newTeams: [Team]) {
//        self.teams = newTeams
//    }
    
    func getTasks() -> [Task] {
        return self.tasks
    }
    
//    func setTasks(_ newTasks: [Task]) {
//        self.tasks = newTasks
//    }
    
    func getFullName() -> String {
        return String(self.firstname + " " + self.lastname)
    }
    
    func getFirstName() -> String {
        return self.firstname
    }
    
//    func setFirstName(_ newName: String) {
//        self.firstname = newName
//    }
    
    func getLastName() -> String {
        return self.lastname
    }
    
//    func setLastName(_ newName: String) {
//        self.lastname = newName
//    }
    
    func getEmailAddress() -> String {
        return self.emailAddress
    }
    
//    func setEmailAddress(_ newEmail: String) {
//        self.emailAddress = newEmail
//    }
    
//    func setEmailAddressForCurrentUser(_ newEmail: String) {
//        Auth.auth().currentUser?.updateEmail(to: newEmail) { (error) in
//            if let error = error { print("Error: Unable to update email address - \(error.localizedDescription)") }
//            else { print("Email address updated successfully.") }
//        }
//    }
    
    func getPhoneNumber() -> String {
        return self.phoneNumber
    }
    
//    func setPhoneNumber(_ newNumber: String) {
//        self.phoneNumber = newNumber
//    }

    func getPassword() -> String {
        if let password = self.password {
            return password
        } else {
            return ""
        }
    }
    
//    func setPasswordForCurrentUser(_ newPassword: String) {
//        Auth.auth().currentUser?.updatePassword(to: newPassword) { (error) in
//            if let error = error { print("Error: Unable to update password - \(error.localizedDescription)") }
//            else { print("Password updated successfully.") }
//        }
//    }
    
    func updateUser(firstname: String?, lastname: String?, email: String?, phone: String?, password: String?) {
        if self.uuid != Globals.User.DEFAULT_UUID {
            Logger.log("updating user information in database", event: .verbose)
            
            let ref = Database.database().reference(withPath: "users/(self.uuid)/information")
            
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
                    if let error = error { Logger.log("unable to update email address - \(error.localizedDescription)", event: .error) }
                    else { Logger.log("Email address updated successfully.", event: .info) }
                }
            }
            
            if let password = password {
                // the password is not stored in the user object
                Auth.auth().currentUser?.updatePassword(to: password) { (error) in
                    if let error = error { Logger.log("Error: Unable to update password - \(error.localizedDescription)", event: .error) }
                    else { Logger.log("Password updated successfully.", event: .info) }
                }
            }
            
        } else {
            Logger.log("unable to update user information in database - no uuid other than default", event: .error)
        }
    }
    
    func updateUserInDatabase() -> (Int, String) {
        if self.uuid != "" {
            print("Updating user information in database...")
            let ref = Database.database().reference(withPath: "users/\(self.uuid)/information")
            ref.child("firstname").setValue(self.getFirstName())
            ref.child("lastname").setValue(self.getLastName())
            ref.child("phone").setValue(self.getPhoneNumber())
            ref.child("email").setValue(self.getEmailAddress())
            return (200, "Success: User information updated successfully.")
        } else {
            print("Failed to update user in database, unable to upload user informaion without UUID.")
            return (404, "Error: Unable to upload a user without the UUID reference.")
        }
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
