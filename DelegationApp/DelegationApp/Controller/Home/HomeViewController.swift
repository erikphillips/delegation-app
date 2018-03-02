//
//  HomeViewController.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/15/17.
//  Copyright © 2017-2018 Erik Phillips. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        Logger.log("Home view controller loaded...")
        
        if let user = user {
            Logger.log("User data retrieved in HomeController")
            Logger.log(user.toString())
        } else {
            Logger.log("No user recieved for HomeViewController", event: .warning)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
