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

        print("Home view controller loaded...")
        
        if let user = user {
            print("User:")
            print(user)
        } else {
            print("No user recieved for HomeViewController")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
