//
//  SettingsViewController.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/13/17.
//  Copyright © 2017 Erik Phillips. All rights reserved.
//

import UIKit

class SettingsTableViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Settings TableView loaded.")
    }
    
    @IBAction func settingsLogout(_ sender: Any) {
        self.performSegue(withIdentifier: "SettingsLogout", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SettingsLogout" {
            print("SettingsLogout segue called.")
        }
    }
    
}

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
    }

}
