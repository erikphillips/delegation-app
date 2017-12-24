//
//  CreateTeamViewController.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/16/17.
//  Copyright © 2017 Erik Phillips. All rights reserved.
//

import UIKit
import Firebase

class CreateTeamViewController: UIViewController {

    var user: User?
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
        if let user = self.user {
            Auth.auth().createUser(withEmail: user.getEmailAddress(), password: user.getPassword()) {
                [weak self](user, error) in
                guard let this = self else { return }
                
                if (user != nil && error == nil) {
                    let uid = Auth.auth().currentUser!.uid
                    this.userUID = uid
                    print("Got UID: \(uid)")
                    
                    let ref = Database.database().reference(withPath: "users/\(uid)")
                    
                    ref.child("firstname").setValue(this.user?.getFirstName())
                    ref.child("lastname").setValue(this.user?.getLastName())
                    ref.child("email").setValue(this.user?.getEmailAddress())
                    ref.child("phone").setValue(this.user?.getPhoneNumber())
                    
                    print("firebase: user added successfully")
                    
                    if let teamName = this.teamNameTextField.text {
                        if let teamDescription = this.teamDescriptionTextView.text {
                            if let uuid = this.userUID {
                                let newTeam = Team(teamname: teamName, description: teamDescription, owner: uuid)
                                
                                let ref = Database.database().reference(withPath: "teams").childByAutoId()
                                ref.child("teamname").setValue(newTeam.getTeamName())
                                ref.child("description").setValue(newTeam.getDescription())
                                ref.child("owner").setValue(newTeam.getOwnerUUID())
                                
                                let userRef = Database.database().reference(withPath: "users/\(uuid)/teams")
                                userRef.child(ref.key).setValue(newTeam.getTeamName())
                                
                                this.performSegue(withIdentifier: "unwindToWelcomeFromCreateTeam", sender: nil)
                            }
                        }
                    }
                    
                } else {
                    print("firebase: failed to add user")
                    print(error?.localizedDescription)
                }
            }
        } else {
            print("createAccountAndNewTeam failed - unable to unwrap user")
        }
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
