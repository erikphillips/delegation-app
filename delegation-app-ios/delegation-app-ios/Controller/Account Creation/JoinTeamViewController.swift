//
//  JoinTeamViewController.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/16/17.
//  Copyright © 2017 Erik Phillips. All rights reserved.
//

import UIKit

class JoinTeamViewController: UIViewController {

    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToTeamPromptView", sender: nil)
    }
    
    @IBAction func createNewAccountAndJoinTeam(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToWelcomeFromJoinTeam", sender: nil)
    }
    
    @IBAction func unwindToJoinTeamView(segue: UIStoryboardSegue) { }
    

}
