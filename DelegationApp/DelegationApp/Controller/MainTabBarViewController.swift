//
//  MainTabBarViewController.swift
//  DelegationApp
//
//  Created by Erik Phillips on 12/16/17.
//  Copyright © 2017-2018 Erik Phillips. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    var user: User?
    var teams: [Team]?
    var tasks: [Task]?

    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.log("loaded custom tab bar controller")
        
        let homeVC = (self.viewControllers![0] as! UINavigationController).viewControllers[0] as! HomeViewController
        let tasksVC = (self.viewControllers![1] as! UINavigationController).viewControllers[0] as! TasksViewController
        let teamVC = (self.viewControllers![2] as! UINavigationController).viewControllers[0] as! TeamViewController
        let settingsVC = (self.viewControllers![3] as! UINavigationController).viewControllers[0] as! SettingsViewController
        
        homeVC.user = self.user
        tasksVC.user = self.user
        teamVC.user = self.user
        settingsVC.user = self.user
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
