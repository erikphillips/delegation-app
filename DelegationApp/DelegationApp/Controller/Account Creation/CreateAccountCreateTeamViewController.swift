//
//  CreateTeamViewController.swift
//  DelegationApp
//
//  Created by Erik Phillips on 12/16/17.
//  Copyright © 2017-2018 Erik Phillips. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountCreateTeamViewController: UIViewController {

    var userDictionary: [String: String]?
    private var userUID: String?
    
    @IBOutlet weak var teamNameTextField: UITextField!
    @IBOutlet weak var teamDescriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToTeamPromptView", sender: nil)
    }
    
    @IBAction func createAccountAndNewTeam(_ sender: Any) {
        if self.teamNameTextField.text! == Globals.TeamGlobals.DEFAULT_TEAMNAME {
            self.displayAlert(title: "Invalid Teamname", message: "Please enter a valid teamname.")
            return
        }
        
        FirebaseUtilities.teamNameInUse(teamname: self.teamNameTextField.text!, callback: {
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
                            let team = Team(teamname: that.teamNameTextField.text!, description: that.teamDescriptionTextView.text!, owner: user.getUUID())
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
            
//            let email = userDictionary["email"] ?? Globals.UserGlobals.DEFAULT_EMAIL
//            let password = userDictionary["password"] ?? Globals.UserGlobals.DEFAULT_PASSWORD
//
//            Auth.auth().createUser(withEmail: email, password: password) {
//                [weak self](user, error) in
//                guard let this = self else { return }
//
//                if (user != nil && error == nil) {
//                    let uid = Auth.auth().currentUser!.uid
//                    this.userUID = uid
//                    Logger.log("Got UID: \(uid)")
//
//                    let ref = Database.database().reference(withPath: "users/\(uid)")
//
//                    ref.child("firstname").setValue(this.userDictionary?["firstname"] ?? Globals.UserGlobals.DEFAULT_FIRSTNAME)
//                    ref.child("lastname").setValue(this.userDictionary?["lastname"] ?? Globals.UserGlobals.DEFAULT_LASTNAME)
//                    ref.child("email").setValue(this.userDictionary?["email"] ?? Globals.UserGlobals.DEFAULT_EMAIL)
//                    ref.child("phone").setValue(this.userDictionary?["phone"] ?? Globals.UserGlobals.DEFAULT_PHONE)
//
//                    Logger.log("firebase: user added successfully")
            
                    // TODO: Fix this to work with the new API
//                    if let teamName = this.teamNameTextField.text {
//                        if let teamDescription = this.teamDescriptionTextView.text {
//                            if let uuid = this.userUID {
//                                let newTeam = Team(teamname: teamName, description: teamDescription, owner: uuid)
//
//                                let ref = Database.database().reference(withPath: "teams").childByAutoId()
//                                ref.child("teamname").setValue(newTeam.getTeamName())
//                                ref.child("description").setValue(newTeam.getDescription())
//                                ref.child("owner").setValue(newTeam.getOwnerUUID())
//
//                                let userRef = Database.database().reference(withPath: "users/\(uuid)/teams")
//                                userRef.child(ref.key).setValue(newTeam.getTeamName())
//
//                                this.performSegue(withIdentifier: "unwindToWelcomeFromCreateTeam", sender: nil)
//                            }
//                        }
//                    }
                    
//                } else {
//                    Logger.log("firebase: failed to add user:", event: .error)
//                    Logger.log(error?.localizedDescription ?? "unknown error", event: .error)
//                }
//            }
    
//    func displayLoadingScreen() {
//        Logger.log("Displaying loading screen.")
//
//        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
//
//        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
//        loadingIndicator.hidesWhenStopped = true
//        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
//        loadingIndicator.startAnimating();
//
//        alert.view.addSubview(loadingIndicator)
//        self.present(alert, animated: true, completion: nil)
//    }
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            Logger.log("You've pressed OK button");
        }
        
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
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
