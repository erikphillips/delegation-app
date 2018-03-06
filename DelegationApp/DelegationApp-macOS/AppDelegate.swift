//
//  AppDelegate.swift
//  macOSDelegationApp
//
//  Created by Erik Phillips on 3/5/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import Cocoa
import AppKit
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        print("applicationDidFinishLaunching called")
        FirebaseApp.configure()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

