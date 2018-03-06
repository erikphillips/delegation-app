//
//  AppDelegate.swift
//  macOSDelegationApp
//
//  Created by Erik Phillips on 3/5/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import Cocoa
import FirebaseCore

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        FirebaseApp.configure() // configure the firebase app
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

