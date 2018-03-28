//
//  Globals.swift
//  DelegationApp
//
//  Created by Erik Phillips on 3/24/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import Foundation

#if TARGET_OS_IOS
import UIKit
#endif

#if TARGET_OS_MACOS
import AppKit
#endif

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
            #if TARGET_OS_IOS  // iOS only code
            static let PRIMARY_LIGHT_WHITE =    UIColor(red: 200/255, green: 225/255, blue: 255/255, alpha: 1.0)
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
            #endif
            
            #if TARGET_OS_MACOS  // macOS only code
            static let PRIMARY_LIGHT_WHITE =    CIColor(red: 200/255, green: 225/255, blue: 255/255, alpha: 1.0)
            static let PRIMARY_LIGHT =          CIColor(red: 171/255, green: 204/255, blue: 255/255, alpha: 1.0)
            static let PRIMARY_MEDIUM_LIGHT =   CIColor(red: 124/255, green: 175/255, blue: 255/255, alpha: 1.0)
            static let PRIMARY =                CIColor(red:  23/255, green: 113/255, blue: 255/255, alpha: 1.0)
            static let PRIMARY_MEDIUM_DARK =    CIColor(red:   0/255, green:  55/255, blue: 143/255, alpha: 1.0)
            static let PRIMARY_DARK =           CIColor(red:   0/255, green:  43/255, blue: 110/255, alpha: 1.0)
            
            static let SECONDARY_LIGHT =        CIColor(red: 255/255, green: 221/255, blue: 163/255, alpha: 1.0)
            static let SECONDARY_MEDIUM_LIGHT = CIColor(red: 255/255, green: 203/255, blue: 111/255, alpha: 1.0)
            static let SECONDARY =              CIColor(red: 255/255, green: 162/255, blue:   0/255, alpha: 1.0)
            static let SECONDARY_MEDUIM_DARK =  CIColor(red: 216/255, green: 138/255, blue:   0/255, alpha: 1.0)
            static let SECONDARY_DARK =         CIColor(red: 166/255, green: 106/255, blue:   0/255, alpha: 1.0)
            #endif
        }
        
    }
}
