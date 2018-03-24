//
//  ObservableNotifications.swift
//  DelegationApp-macOS
//
//  Created by Erik Phillips on 3/23/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

/*
 
 Example Notification Center Code
 
 The following static property should be added to the top of the class:
 static let notificationName = Notification.Name("myNotificationName")
 
 Then the notification can be observed (added in the viewDidLoad method):
 NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: MainViewController.notificationName, object: nil)
 
 To stop observing the notification:
 NotificationCenter.default.removeObserver(self, name: MainViewController.notificationName, object: nil)
 
 Or stop observing all notifications:
 NotificationCenter.default.removeObserver(self)
 
 Then the function (objective c) is called:
 @objc func onNotification(notification:Notification) { print(notification.userInfo) }
 
 To post the notification (notify all observers):
 NotificationCenter.default.post(name: MainViewController.notificationName, object: nil, userInfo:["data": 42, "isImportant": true])
 
 */


import Foundation


class ObservableNotifications {
    
    static let NOTIFICATION_APP_LAUNCH = Notification.Name("NOTIFICATION_SEGMENT_PERSONAL")
    static let NOTIFICATION_APP_LOGOUT = Notification.Name("NOTIFICATION_APP_LOGOUT")
    
    static let NOTIFICATION_SEGMENT_CHANGED = Notification.Name("NOTIFICATION_SEGMENT_CHANGED")
    
    static let NOTIFICATION_ALL_TEAM_SELECTION = Notification.Name("NOTIFICATION_ALL_TEAM_SELECTION")
    static let NOTIFICATION_TEAM_SELECTION = Notification.Name("NOTIFICATION_TEAM_SELECTION")
    
}

//extension Notification.Name {
//    static let NOTIFICATION_SEGMENT_PERSONAL = Notification.Name(
//        rawValue: "NOTIFICATION_SEGMENT_PERSONAL")
//}

