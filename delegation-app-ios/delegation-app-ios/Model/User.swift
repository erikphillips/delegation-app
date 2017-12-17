//
//  User.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/10/17.
//  Copyright © 2017 Erik Phillips. All rights reserved.
//

import Foundation

class User {
    private var teams : [Team]
    private var tasks : [Task]
    
    private var firstname: String
    private var lastname: String
    private var emailAddress: String
    private var phoneNumber: String
    private var password: String?

    init(firstname: String, lastname: String, email: String, phone: String) {
        self.firstname = firstname
        self.lastname = lastname
        self.emailAddress = email
        self.phoneNumber = phone
        self.password = nil
        
        self.teams = []
        self.tasks = []
        
        print("Created new user instance: \(self.firstname), \(self.lastname), \(self.emailAddress), \(self.phoneNumber)")
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
