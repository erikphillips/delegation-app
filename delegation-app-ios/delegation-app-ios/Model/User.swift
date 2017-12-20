//
//  User.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/10/17.
//  Copyright © 2017 Erik Phillips. All rights reserved.
//

import Foundation
import Firebase

class User {
    private var teams : [Team]
    private var tasks : [Task]
    
    private var uid: String
    private var firstname: String
    private var lastname: String
    private var emailAddress: String
    private var phoneNumber: String
    private var password: String?

    init(uid: String, firstname: String, lastname: String, email: String, phone: String) {
        self.uid = uid
        self.firstname = firstname
        self.lastname = lastname
        self.emailAddress = email
        self.phoneNumber = phone
        self.password = nil
        
        self.teams = []
        self.tasks = []
        
        print("Created new user instance: \(self.firstname), \(self.lastname), \(self.emailAddress), \(self.phoneNumber)")
    }
    
    init(uid: String, snapshot: DataSnapshot) {
        let value = snapshot.value as? NSDictionary
        
        self.uid = uid
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
        return self.phoneNumber
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
