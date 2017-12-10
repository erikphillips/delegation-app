//
//  User.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/10/17.
//  Copyright © 2017 Erik Phillips. All rights reserved.
//

import Foundation

class User {
    private var information : UserInformation
    private var groups : [Group]
    private var tasks : [Task]
    
    init(information: UserInformation) {
        self.information = information
        self.groups = []
        self.tasks = []
    }
}

class UserInformation {
    private var firstname : String
    private var lastname : String
    private var emailAddress : String
    private var phoneNumber : String
    
    init(firstname: String, lastname: String, emailAddress: String, phoneNumber: String) {
        self.firstname = firstname
        self.lastname = lastname
        self.emailAddress = emailAddress
        self.phoneNumber = phoneNumber
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
