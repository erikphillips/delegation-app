//
//  SettingsCreateTeamViewController.swift
//  DelegationApp
//
//  Created by Erik Phillips on 1/8/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import UIKit

class SettingsCreateTeamViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    var user: User?
    
    @IBOutlet weak var teamTitleTextField: UITextField!
    @IBOutlet weak var teamDescriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        self.teamTitleTextField.delegate = self
        self.teamDescriptionTextView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case teamTitleTextField:
            textField.resignFirstResponder()
            self.teamDescriptionTextView.becomeFirstResponder()
            break
        case teamDescriptionTextView:
            textField.resignFirstResponder()
            self.createNewTeamButtonPressed(self)
            break
        default:
            textField.resignFirstResponder()
            break
        }
        
        return false
    }
    
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        switch textView {
        case teamDescriptionTextView:
            textView.resignFirstResponder()
            self.createNewTeamButtonPressed(self)
            break
        default:
            textView.resignFirstResponder()
            break
        }
        
        return false
    }
    
    @IBAction func createNewTeamButtonPressed(_ sender: Any) {
        let teamname = Utilities.trimWhitespace(self.teamTitleTextField.text!)
        
        if teamname == Globals.TeamGlobals.DEFAULT_TEAMNAME {
            self.displayAlert(title: "Invalid Teamname", message: "Please enter a valid teamname.")
            return
        }
        
        if let user = user {
            FirebaseUtilities.teamNameInUse(teamname: teamname, callback: {
                [weak self] (status) in
                guard let this = self else { return }
                
                if !status.status {
                    this.displayAlert(title: "Invalid Team Name", message: status.message)
                } else {
                    let team = Team(teamname: Utilities.trimWhitespace(this.teamTitleTextField.text!), description: this.teamDescriptionTextView.text!, owner: user.getUUID())
                    
                    if let user = this.user {
                        user.addNewTeam(guid: team.getGUID())
                    } else {
                        Logger.log("unable to unwrap user to add guid", event: .error)
                    }
                    
                    this.performSegue(withIdentifier: "UnwindToMainSettingsTable", sender: nil)
                }
            })
        } else {
            Logger.log("unable to unwrap user object", event: .error)
        }
    }
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            Logger.log("You've pressed OK button");
        }
        
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { }

}
