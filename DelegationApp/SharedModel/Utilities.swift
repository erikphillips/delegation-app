//
//  Utilities.swift
//  DelegationApp
//
//  Created by Erik Phillips on 12/20/17.
//  Copyright © 2017-2018  Erik Phillips. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase


class Utilities {
    
    static func trimWhitespace(_ string: String) -> String {
        return string.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    static func validateEmail(_ email: String) -> Status {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if emailTest.evaluate(with: email) {
            return Status(true)
        } else {
            return Status(false, "Email must match the format: 'name@domain.com'")
        }
    }
    
    static func validatePhoneNumber(_ phoneNumber: String) -> Status {
        if Utilities.format(phoneNumber: phoneNumber) != nil {
            return Status(true)
        } else {
            return Status(false, "The phone number is incorrectly formatted or non-existant.")
        }
    }
    
    static func validatePassword(_ pswd: String) -> Status {
        if pswd == "" {
            return Status(false, "Password is required.")
        }
        
        if pswd.count < Globals.UserGlobals.MINIMUM_PASSWORD_LENGTH {
            return Status(false, "Password length must be \(Globals.UserGlobals.MINIMUM_PASSWORD_LENGTH) characters or longer.")
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
            if user.getFirstName() == Globals.UserGlobals.DEFAULT_FIRSTNAME {
                return Status(false, "User object is missing a valid first name.")
            } else if user.getLastName() == Globals.UserGlobals.DEFAULT_LASTNAME {
                return Status(false, "User object is missing a valid last name.")
            } else if user.getEmailAddress() == Globals.UserGlobals.DEFAULT_EMAIL {
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
            if task.getTitle() == Globals.TaskGlobals.DEFAULT_TITLE {
                return Status(false, "Task object is missing a valid title")
            } else if task.getDescription() == Globals.TaskGlobals.DEFAULT_DESCRIPTION {
                return Status(false, "Task object is missing a valid description")
            } else if task.getAssigneeUUID() == Globals.TaskGlobals.DEFAULT_ASSIGNEE {
                return Status(false, "Task object is missing a valid assignee")
            } else if task.getTeamUID() == Globals.TaskGlobals.DEFAULT_TEAM {
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
            if team.getTeamName() == Globals.TeamGlobals.DEFAULT_TEAMNAME {
                return Status(false, "Team object is missing a valid teamname")
            } else if team.getDescription() == Globals.TeamGlobals.DEFAULT_DESCRIPTION {
                return Status(false, "Team object is missing a valid description")
            } else if team.getOwnerUUID() == Globals.TeamGlobals.DEFAULT_OWNER {
                return Status(false, "Team object is missing a valid owner")
            } else {
                return Status(true, "Team ibject is considered valid (teamname, description, owner)")
            }
        } else {
            return Status(false, "Team object is an optional set as nil")
        }
    }
    
    static func unformat(phoneNumber sourcePhoneNumber: String) -> String {
        return sourcePhoneNumber.trimmingCharacters(in: CharacterSet(charactersIn: "01234567890.").inverted)
    }
    
    static func format(phoneNumber sourcePhoneNumber: String) -> String? {
        // Remove any character that is not a number
        let numbersOnly = sourcePhoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let length = numbersOnly.count
        let hasLeadingOne = numbersOnly.hasPrefix("1")
        
        // Check for supported phone number length
        guard length == 7 || length == 10 || (length == 11 && hasLeadingOne) else {
            return nil
        }
        
        let hasAreaCode = (length >= 10)
        var sourceIndex = 0
        
        // Leading 1
        var leadingOne = ""
        if hasLeadingOne {
            leadingOne = "1 "
            sourceIndex += 1
        }
        
        // Area code
        var areaCode = ""
        if hasAreaCode {
            let areaCodeLength = 3
            guard let areaCodeSubstring = numbersOnly.substring(start: sourceIndex, offsetBy: areaCodeLength) else {
                return nil
            }
            areaCode = String(format: "(%@) ", areaCodeSubstring)
            sourceIndex += areaCodeLength
        }
        
        // Prefix, 3 characters
        let prefixLength = 3
        guard let prefix = numbersOnly.substring(start: sourceIndex, offsetBy: prefixLength) else {
            return nil
        }
        sourceIndex += prefixLength
        
        // Suffix, 4 characters
        let suffixLength = 4
        guard let suffix = numbersOnly.substring(start: sourceIndex, offsetBy: suffixLength) else {
            return nil
        }
        
        return leadingOne + areaCode + prefix + "-" + suffix
    }
    
    static func userMemberOfTeam(user: User, team: Team) -> Bool {
        for t in user.getTeams() { if team.getGUID() == t.getGUID() { return true } }
        return false
    }
    
    class Filtering {
        
        static func filter(tasks: [Task], by teamname: String) -> [Task] {
            var rtn: [Task] = []
            for task in tasks {
                if task.getTeamUID() == teamname {
                    rtn.append(task)
                }
            }
            return rtn
        }
        
//        func filtering(tasks: [Task], by team: Team) -> [Task] {
//            return tasks.filter { $0.getTeamUID() == team.getGUID() }
//        }
//
//        func filtering(tasks: [Task], by user: User) -> [Task] {
//            return tasks.filter { $0.getAssigneeUUID() == user.getUUID() }
//        }
        
        static func distict(tasks: [Task]) -> [Task]? {
            var tuids: [String] = []
            var rtnTasks: [Task] = []
            
            for task in tasks {
                if (!tuids.contains(task.getTUID())) {
                    rtnTasks.append(task)
                    tuids.append(task.getTUID())
                }
            }
            
            return rtnTasks
        }
        
    }
}

extension String {
    /// This method makes it easier extract a substring by character index where a character is viewed as a human-readable character (grapheme cluster).
    internal func substring(start: Int, offsetBy: Int) -> String? {
        guard let substringStartIndex = self.index(startIndex, offsetBy: start, limitedBy: endIndex) else {
            return nil
        }
        
        guard let substringEndIndex = self.index(startIndex, offsetBy: start + offsetBy, limitedBy: endIndex) else {
            return nil
        }
        
        return String(self[substringStartIndex ..< substringEndIndex])
    }
}

class FirebaseUtilities {
    
    static func createNewUser(email: String, password: String, callback: @escaping ((_ uuid: String, _ status: Status) -> Void)) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error == nil, let user = user {
                Logger.log("new user account created successfully \(user.uid)")
                callback(user.uid, Status(true))
            } else {
                Logger.log("an error occurred creating a new user account - \(error?.localizedDescription ?? "unknown error")", event: .severe)
                callback(Globals.UserGlobals.DEFAULT_UUID, Status(false, error?.localizedDescription ?? "unknown error"))
            }
        }
    }
    
    static func deleteCurrentUserAccount(callback: @escaping ((_ status: Int) -> Void)) {
        callback(500)
    }
    
    static func logoutCurrentUser() -> Status {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            Logger.log("Error signing out: \(signOutError.localizedDescription)", event: .severe)
            return Status(false, signOutError.localizedDescription)
        }
        
        return Status(true)
    }
    
    static func loginUser(username: String, password: String, callback: @escaping ((_ uuid: String?, _ error: Error?) -> Void)) {
        Auth.auth().signIn(withEmail: username, password: password) {
            (user, error) in
            if let user = user {
                callback(user.uid, nil)
            } else {
                Logger.log("Error found logging in user. \(error?.localizedDescription ?? "Unknown Error")", event: .error)
                callback(nil, error)
            }
        }
    }
    
    static func emailAddressInUse(email: String, callback: @escaping ((_ status: Status) -> Void)) {
        Auth.auth().fetchProviders(forEmail: email, completion: {
            (providers, error) in
            
            if let error = error {
                Logger.log(error.localizedDescription, event: .severe)
            } else if let providers = providers {
                if providers.count > 0 {
                    callback(Status(false, "The email address appears to already be in use."))
                }
            }
            
            callback(Status(true))
        })
    }
    
    static func teamNameInUse(teamname: String, callback: @escaping ((_ status: Status) -> Void)) {
        let ref = Database.database().reference(withPath: "teams/\(teamname)")

        ref.observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            if snapshot.exists() {
                callback(Status(false, "The team name is already in use. Please choose another name."))
            } else {
                callback(Status(true, "The team name is available."))
            }

        }) { (error) in
            print(error.localizedDescription)
            callback(Status(false, error.localizedDescription))
        }
    }
    
    static func fetchAllTeams(callback: @escaping ((_ teams: [Team]) -> Void)) {
        let ref = Database.database().reference(withPath: "teams/")
        ref.observeSingleEvent(of: DataEventType.value, with: {
            (snapshot) in
            
            var teams: [Team] = []
            if let dict = snapshot.value as? NSDictionary {
                for (key, _) in dict {
                    if let key = key as? String {
                        teams.append(Team(guid: key))
                    }
                }
            }
            
            callback(teams)
        })
    }
    
    static func fetchAllTeamGUIDs(callback: @escaping ((_ teams: [String]) -> Void)) {
        let ref = Database.database().reference(withPath: "teams")
        ref.observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            var teams: [String] = []
            if let dict = snapshot.value as? NSDictionary {
                for (key, _) in dict {
                    if let key = key as? String {
                        teams.append(key)
                    }
                }
            }
            
            callback(teams)
        })
    }
        
    static func performWelcomeProcedure(username: String, password: String, callback: @escaping ((_ user: User?, _ tasks: [Task]?, _ status: Status) -> Void)) {
        loginUser(username: username, password: password, callback: { (uuid, error) in
            if let uuid = uuid {
                if uuid != Globals.UserGlobals.DEFAULT_UUID {  // verify that the UUID is not simply the default UUID
                    
                    let welcome_user: User? = User(uuid: uuid)  // Initialize the begining values for the master return objects
                    
                    let userInitialSetupComplete = {
                        [callback] (user: User) in
                        Logger.log("user information loaded, marking as completed")
                        Logger.log("TODO: the task data has not been loaded", event: .warning)
                        callback(user, nil, Status(false, "Unable to read tasks array after dispatch finished."))
                    }
                    
                    if let user = welcome_user {
                        userInitialSetupComplete(user)
                    }
                    
                } else {
                    Logger.log("unable to fetch user without default uuid, returning nil,nil,error", event: .error)
                    callback(nil, nil, Status(false, "Unable to fetch user without default uuid."))
                }
                
            } else {
                Logger.log("unable to fetch user, returning nil,nil,false", event: .error)
                print(String(describing: error?.localizedDescription))
                callback(nil, nil, Status(false, "Unable to fetch user. " + (error?.localizedDescription ?? "")))
            }
            
        })
    }
    
}
