//
//  CreateTeamViewController.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/16/17.
//  Copyright © 2017-2018 Erik Phillips. All rights reserved.
//

import UIKit
import Firebase

class CreateTeamViewController: UIViewController {

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
        if let userDictionary = self.userDictionary {
            
            let email = userDictionary["email"] ?? Globals.UserGlobals.DEFAULT_EMAIL
            let password = userDictionary["password"] ?? Globals.UserGlobals.DEFAULT_PASSWORD
            
            Auth.auth().createUser(withEmail: email, password: password) {
                [weak self](user, error) in
                guard let this = self else { return }
                
                if (user != nil && error == nil) {
                    let uid = Auth.auth().currentUser!.uid
                    this.userUID = uid
                    Logger.log("Got UID: \(uid)")
                    
                    let ref = Database.database().reference(withPath: "users/\(uid)")
                    
                    ref.child("firstname").setValue(this.userDictionary?["firstname"] ?? Globals.UserGlobals.DEFAULT_FIRSTNAME)
                    ref.child("lastname").setValue(this.userDictionary?["lastname"] ?? Globals.UserGlobals.DEFAULT_LASTNAME)
                    ref.child("email").setValue(this.userDictionary?["email"] ?? Globals.UserGlobals.DEFAULT_EMAIL)
                    ref.child("phone").setValue(this.userDictionary?["phone"] ?? Globals.UserGlobals.DEFAULT_PHONE)
                    
                    Logger.log("firebase: user added successfully")
                    
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
                    
                } else {
                    Logger.log("firebase: failed to add user:", event: .error)
                    Logger.log(error?.localizedDescription ?? "unknown error", event: .error)
                }
            }
        } else {
            Logger.log("createAccountAndNewTeam failed - unable to unwrap user", event: .error)
        }
    }
    
    func displayLoadingScreen() {
        Logger.log("Displaying loading screen.")
        
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        self.present(alert, animated: true, completion: nil)
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
