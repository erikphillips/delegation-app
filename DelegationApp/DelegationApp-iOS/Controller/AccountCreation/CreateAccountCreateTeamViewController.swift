//
//  CreateTeamViewController.swift
//  DelegationApp
//
//  Created by Erik Phillips on 12/16/17.
//  Copyright © 2017-2018 Erik Phillips. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountCreateTeamViewController: UIViewController, UITextFieldDelegate {

    var userDictionary: [String: String]?
    private var userUID: String?
    
    @IBOutlet weak var teamNameTextField: UITextField!
    @IBOutlet weak var teamDescriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.teamNameTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case teamNameTextField:
            textField.resignFirstResponder()
            self.teamDescriptionTextView.becomeFirstResponder()
            break
        default:
            textField.resignFirstResponder()
            break
        }
        
        return false
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToTeamPromptView", sender: nil)
    }
    
    @IBAction func createAccountAndNewTeam(_ sender: Any) {
        let teamname = Utilities.trimWhitespace(self.teamNameTextField.text!)
        
        if teamname == Globals.TeamGlobals.DEFAULT_TEAMNAME {
            self.displayAlert(title: "Invalid Teamname", message: "Please enter a valid teamname.")
            return
        }
        
        FirebaseUtilities.teamNameInUse(teamname: teamname, callback: {
            [weak self] (status) in
            guard let this = self else { return }
            
            if !status.status {
                this.displayAlert(title: "Invalid Team Name", message: status.message)
            } else {
                if let dict = this.userDictionary {
                    FirebaseUtilities.createNewUser(email: dict["email"]!, password: dict["password"]!, callback: {
                        [weak this] (uuid, status) in
                        guard let that = this else { return }
                        if status.status {
                            Logger.log("new user created: \(uuid)")
                            let user = User(uuid: uuid, firstname: dict["firstname"]!, lastname: dict["lastname"]!, phoneNumber: dict["phone"]!, emailAddress: dict["email"]!)
                            let team = Team(teamname: Utilities.trimWhitespace(that.teamNameTextField.text!), description: that.teamDescriptionTextView.text!, owner: user.getUUID())
                            user.addNewTeam(guid: team.getGUID())
                            that.performSegue(withIdentifier: "unwindToWelcomeFromCreateTeam", sender: nil)
                        } else {
                            Logger.log("error creating a new user in firebase - \(status.message)", event: .error)
                            that.displayAlert(title: "Error Creating Account", message: status.message)
                        }
                    })
                } else {
                    Logger.log("createAccountAndNewTeam failed - unable to unwrap user dictionary", event: .error)
                }
            }
        })
    }
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            Logger.log("You've pressed OK button");
        }
        
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }

}
