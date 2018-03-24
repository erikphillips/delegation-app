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


class ObservableNotifications {
    
    static let NOTIFICATION_APP_LAUNCH: String = "NOTIFICATION_APP_LAUNCH"
    
    static let NOTIFICATION_WINDOW_MAIN_OPEN: String = "NOTIFICATION_WINDOW_MAIN_OPEN"
    static let NOTIFICATION_WINDOW_MAIN_CLOSE: String = "NOTIFICATION_WINDOW_MAIN_CLOSE"
    
    static let NOTIFICATION_SEGMENT_SELF: String = "NOTIFICATION_SEGMENT_SELF"
    static let NOTIFICATION_SEGMENT_TEAM: String = "NOTIFICATION_SEGMENT_TEAM"
    static let NOTIFICATION_SEGMENT_DELEGATION: String = "NOTIFICATION_SEGMENT_DELEGATION"
    
    static let NOTIFICATION_TEAM_SELECTION_PREFIX: String = "NOTIFICATION_TEAM_SELECTION_"
    
}
