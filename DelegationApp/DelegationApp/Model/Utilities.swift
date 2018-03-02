//
//  Utilities.swift
//  DelegationApp
//
//  Created by Erik Phillips on 12/20/17.
//  Copyright © 2017-2018  Erik Phillips. All rights reserved.
//

import Foundation
import Firebase

class Globals {
    public class TaskGlobals {
        static let DEFAULT_TITLE: String = ""
        static let DEFAULT_PRIORITY: String = "5"
        static let DEFAULT_DESCRIPTION: String = ""
        static let DEFAULT_TEAM: String = ""
        static let DEFAULT_STATUS: TaskStatus = .none
        static let DEFAULT_ASSIGNEE: String = ""
        static let DEFAULT_ORIGINATOR: String = ""
        static let DEFAULT_TUID: String = ""
        static let DEFAULT_UUID: String = ""
    }
    
    public class UserGlobals {
        static let DEFAULT_FULL_NAME: String = ""
        static let DEFAULT_FIRSTNAME: String = ""
        static let DEFAULT_LASTNAME: String = ""
        static let DEFAULT_EMAIL: String = ""
        static let DEFAULT_PHONE: String = ""
        static let DEFAULT_UUID: String = ""
    
        static let DEFAULT_PASSWORD: String = ""
        static let MINIMUM_PASSWORD_LENGTH: Int = 6
        
        static let DEFAULT_TASKS: [Task] = []
        static let DEFAULT_TEAMS: [Team] = []
    }
    
    public class TeamGlobals {
        static let DEFAULT_TEAMNAME: String = ""
        static let DEFAULT_OWNER: String = ""
        static let DEFAULT_DESCRIPTION: String = ""
        static let DEFAULT_MEMBERS: [String] = []
        static let DEFAULT_GUID: String = ""
    }
    
    public class ApplicationGlobals {
        static let VERSION: String = "v0.1"
    }
    
    public class UIGlobals {
        public class Colors {
            static let PRIMARY_LIGHT =          UIColor(red: 171/255, green: 204/255, blue: 255/255, alpha: 1.0)
            static let PRIMARY_MEDIUM_LIGHT =   UIColor(red: 124/255, green: 175/255, blue: 255/255, alpha: 1.0)
            static let PRIMARY =                UIColor(red:  23/255, green: 113/255, blue: 255/255, alpha: 1.0)
            static let PRIMARY_MEDIUM_DARK =    UIColor(red:   0/255, green:  55/255, blue: 143/255, alpha: 1.0)
            static let PRIMARY_DARK =           UIColor(red:   0/255, green:  43/255, blue: 110/255, alpha: 1.0)
            
            static let SECONDARY_LIGHT =        UIColor(red: 255/255, green: 221/255, blue: 163/255, alpha: 1.0)
            static let SECONDARY_MEDIUM_LIGHT = UIColor(red: 255/255, green: 203/255, blue: 111/255, alpha: 1.0)
            static let SECONDARY =              UIColor(red: 255/255, green: 162/255, blue:   0/255, alpha: 1.0)
            static let SECONDARY_MEDUIM_DARK =  UIColor(red: 216/255, green: 138/255, blue:   0/255, alpha: 1.0)
            static let SECONDARY_DARK =         UIColor(red: 166/255, green: 106/255, blue:   0/255, alpha: 1.0)
        }
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
//    static func extractTeamsFromSnapshot(_ snapshot: DataSnapshot) -> [Team] {
//        print("Extracting teams...")
//
//        var teams: [Team] = []
//
//        if let value = (snapshot.value as? NSDictionary) {
//            for elem in value {
//                if let teamData = elem.value as? NSDictionary {
//                    let teamname = teamData["teamname"] as? String ?? ""
//                    let uid = elem.key as? String ?? ""
//                    teams.append(Team(teamname: teamname, uid: uid))
//                }
//            }
//        }
//
//        print("Found \(teams.count) teams")
//
//        return teams
//    }
    
//    static func extractUserInformationFromSnapshot(_ snapshot: DataSnapshot) -> User {
//        let value = snapshot.value as? NSDictionary
//
//        let firstname = value?["firstname"] as? String ?? Globals.UserGlobals.DEFAULT_FIRSTNAME
//        let lastname = value?["lastname"] as? String ?? Globals.UserGlobals.DEFAULT_LASTNAME
//        let email = value?["email"] as? String ?? Globals.UserGlobals.DEFAULT_EMAIL
//        let phone = value?["phone"] as? String ?? Globals.UserGlobals.DEFAULT_PHONE
//        let uuid = Globals.UserGlobals.DEFAULT_UUID
//
//        return User(uid: uuid, firstname: firstname, lastname: lastname, email: email, phone: phone)
//    }
    
//    static func extractUserInformationFromSnapshot(_ snapshot: DataSnapshot, uuid: String) -> User {
//        let value = snapshot.value as? NSDictionary
//
//        let firstname = value?["firstname"] as? String ?? Globals.UserGlobals.DEFAULT_FIRSTNAME
//        let lastname = value?["lastname"] as? String ?? Globals.UserGlobals.DEFAULT_LASTNAME
//        let email = value?["email"] as? String ?? Globals.UserGlobals.DEFAULT_EMAIL
//        let phone = value?["phone"] as? String ?? Globals.UserGlobals.DEFAULT_PHONE
//
//        return User(uid: uuid, firstname: firstname, lastname: lastname, email: email, phone: phone)
//    }
    
//    static func getUserInformation(uid: String, callback: @escaping ((_ user: User?, _ status: Status) -> Void)) {
//        var ref: DatabaseReference!
//        ref = Database.database().reference()
//
//        ref.child("users/\(uid)/information").observeSingleEvent(of: .value, with: {
//            (snapshot) in
//
//            let user = FirebaseUtilities.extractUserInformationFromSnapshot(snapshot, uuid: uid)
//            let userStatus = Utilities.validateUser(user)
//            if userStatus.status {
//                callback(user, userStatus)
//            } else {
//                callback(nil, userStatus)
//            }
//        }) { (error) in
//            print(error.localizedDescription)
//            callback(nil, Status(false, error.localizedDescription))
//        }
//    }
    
//    static func extractTeamInformationFromSnapshot(_ snapshot: DataSnapshot) -> Team {
//        let value = snapshot.value as? NSDictionary
//
//        let teamname = value?["teamname"] as? String ?? Globals.TeamGlobals.DEFAULT_TEAMNAME
//        let description = value?["description"] as? String ?? Globals.TeamGlobals.DEFAULT_DESCRIPTION
//        let owner = value?["owner"] as? String ?? Globals.TeamGlobals.DEFAULT_OWNER
//
//        return Team(teamname: teamname, description: description, owner: owner)
//    }
    
//    static func getTeamInformation(guid: String, callback: @escaping ((_ team: Team?, _ status: Status) -> Void)) {
//        var ref: DatabaseReference
//        ref = Database.database().reference()
//
//        ref.child("teams/\(guid)/information").observeSingleEvent(of: .value, with: {
//            (snapshot) in
//
//            callback(FirebaseUtilities.extractTeamInformationFromSnapshot(snapshot), Status(true))
//
//        }) { (error) in
//            print(error.localizedDescription)
//            callback(nil, Status(false, error.localizedDescription))
//        }
//    }
    
//    static func getAllTeams(callback: @escaping ((_ teams: [Team]?, _ status: Status) -> Void)) {
//        let ref: DatabaseReference! = Database.database().reference()
//        ref.child("teams").observeSingleEvent(of: .value, with: { (snapshot) in
//            let teams = FirebaseUtilities.extractTeamsFromSnapshot(snapshot)
//            callback(teams, Status(true))
//        }) { (error) in
//            print(error.localizedDescription)
//            callback(nil, Status(false, error.localizedDescription))
//        }
//    }
    
//    static func extractTaskFromSnapshot(_ snapshot: DataSnapshot) -> Task {
//        let value = snapshot.value as? NSDictionary
//
//        let title = value?["title"] as? String ?? Globals.TaskGlobals.DEFAULT_TITLE
//        let priority = value?["priority"] as? String ?? Globals.TaskGlobals.DEFAULT_PRIORITY
//        let description = value?["description"] as? String ?? Globals.TaskGlobals.DEFAULT_DESCRIPTION
//        let team = value?["team"] as? String ?? Globals.TaskGlobals.DEFAULT_TEAM
//        let status = value?["status"] as? String ?? Globals.TaskGlobals.DEFAULT_STATUS
//        let resolution = value?["resolution"] as? String ?? Globals.TaskGlobals.DEFAULT_RESOLUTION
//        let assignee = value?["assignee"] as? String ?? Globals.TaskGlobals.DEFAULT_ASSIGNEE
//        let originatorUUID = value?["originator"] as? String ?? ""
//
//        return Task(title: title, priority: priority, description: description, team: team, status: status, resolution: resolution, assigneeUUID: assignee, originatorUUID: originatorUUID)
//    }
    
//    static func getTask(tuid: String, callback: @escaping ((_ task: Task?, _ status: Status) -> Void)) {
//        var ref: DatabaseReference
//        ref = Database.database().reference()
//
//        ref.child("tasks/\(tuid)").observeSingleEvent(of: .value, with: {
//            (snapshot) in
//
//            callback(FirebaseUtilities.extractTaskFromSnapshot(snapshot), Status(true))
//
//        }) { (error) in
//            print(error.localizedDescription)
//            callback(nil, Status(false, error.localizedDescription))
//        }
//    }
    
//    static func createTask(_ task: Task) {
//        var ref: DatabaseReference
//        ref = Database.database().reference(withPath: "tasks/\(task.getAssigneeUUID())/current_tasks").childByAutoId()
//
//        ref.child("title").setValue(task.getTitle())
//        ref.child("priority").setValue(task.getPriority())
//        ref.child("description").setValue(task.getDescription())
//        ref.child("team").setValue(task.getTeamUID())
//        ref.child("status").setValue(task.getStatus())
//        ref.child("resolution").setValue(task.getResolution())
//        ref.child("assignee").setValue(task.getAssigneeUUID())
//    }
    
//    static func getCurrentTaskIDs(uuid: String, callback: @escaping ((_ taskIDs: [String]?, _ status: Status) -> Void)) {
//        var ref: DatabaseReference
//        ref = Database.database().reference()
//
//        print("Attempting to read: 'tasks/\(uuid)/current_tasks'...")
//        ref.child("tasks/\(uuid)/current_tasks").observeSingleEvent(of: .value, with: { (snapshot) in
//            if let values = snapshot.value as? NSDictionary {
//                var ids: [String] = []
//                for (key, value) in values {
//                    if let value = value as? String {
//                        ids.append(value)
//                    } else {
//                        print("Unable to get value from key=\((key as? String) ?? "") as string")
//                    }
//                }
//
//                callback(ids, Status(true))
//            } else {
//                print("getCurrentTaskIDs: warning, unable to get value as NSDictionary")
//                callback(nil, Status(false, "unable to retrieve task ids as an NSDictionary."))
//            }
//        })
//    }
    
//    static func updateCurrentUserEmailAddress(_ email: String, callback: @escaping ((_ status: Status) -> Void)) {
//        let emailStatus = Utilities.validateEmail(email)
//        if emailStatus.status {
//            Auth.auth().currentUser?.updateEmail(to: email) { (error) in
//                if let error = error {
//                    print("Error: Unable to update email address - \(error.localizedDescription)")
//                    callback(Status(false, error.localizedDescription))
//                } else {
//                    print("Email address updated successfully.")
//                    callback(Status(true))
//                }
//            }
//        } else {
//            callback(emailStatus)
//        }
//    }
    
//    static func updateCurrentUserPassword(_ password: String, callback: @escaping ((_ status: Status) -> Void)) {
//        let passwordStatus = Utilities.validatePassword(password)
//        if passwordStatus.status {
//            Auth.auth().currentUser?.updatePassword(to: password) { (error) in
//                if let error = error {
//                    print("Error: Unable to update password - \(error.localizedDescription)")
//                    callback(Status(false, error.localizedDescription))
//                } else {
//                    print("Password updated successfully.")
//                    callback(Status(true))
//                }
//            }
//        } else {
//            callback(passwordStatus)
//        }
//    }
    
//    static func updateCurrentUser(user: User, callback: @escaping ((_ status: Status) -> Void)) {
//        var ref: DatabaseReference
//        ref = Database.database().reference()
//
//        ref.child("users/\(user.getUUID())/information").observeSingleEvent(of: .value, with: {
//            (snapshot) in
//
//            let ref = Database.database().reference(withPath: "users/\(user.getUUID())/information")
//            ref.child("firstname").setValue(user.getFirstName())
//            ref.child("lastname").setValue(user.getLastName())
//            ref.child("phone").setValue(user.getPhoneNumber())
//            ref.child("email").setValue(user.getEmailAddress())
//
//        }) { (error) in
//            print(error.localizedDescription)
//            callback(Status(false, error.localizedDescription))
//        }
//    }
    
//    static func createNewUser(newUser: User, selectedTeams: [String], callback: @escaping ((_ status: Status) -> Void)) {
//        Auth.auth().createUser(withEmail: newUser.getEmailAddress(), password: newUser.getPassword()) {
//            (user, error) in
//
//            if (user != nil && error == nil) {
//                let uid = Auth.auth().currentUser!.uid
//                print("Got new user UID: \(uid)")
//
//                let ref = Database.database().reference(withPath: "users/\(uid)/information/")
//                ref.child("firstname").setValue(newUser.getFirstName())
//                ref.child("lastname").setValue(newUser.getLastName())
//                ref.child("email").setValue(newUser.getEmailAddress())
//                ref.child("phone").setValue(newUser.getPhoneNumber())
//
//                let teamsRef = Database.database().reference(withPath: "users/\(uid)/teams/")
//                for id in selectedTeams {
//                    teamsRef.childByAutoId().setValue(id)
//                }
//
//                print("firebase: user added successfully")
//
//                callback(Status(true))
//            } else {
//                print("firebase: failed to add user")
//                print(String(describing:error?.localizedDescription))
//                callback(Status(false, error?.localizedDescription ?? "Unknown error"))
//            }
//        }
//    }
    
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
    
    static func performWelcomeProcedure(controller: UIViewController, username: String, password: String, callback: @escaping ((_ user: User?, _ tasks: [Task]?, _ status: Status) -> Void)) {
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
//                        user.observers.observe(canary: self, callback: userInitialSetupComplete)
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
