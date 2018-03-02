//
//  CreateTaskViewController.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/29/17.
//  Copyright © 2017-2018 Erik Phillips. All rights reserved.
//

import UIKit

class CreateTaskViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {

    var user: User?
    var selectedGUID: String?
    
    @IBOutlet weak var taskTitleTextField: UITextField!
    @IBOutlet weak var taskTeamTextField: UITextField!
    @IBOutlet weak var taskDescriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        self.taskTeamTextField.delegate = self
        self.taskTeamTextField.delegate = self
        self.taskDescriptionTextView.delegate = self
        
        if let selectedGUID = self.selectedGUID {
            self.taskTeamTextField.text = selectedGUID
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let selectedGUID = self.selectedGUID {
            self.taskTeamTextField.text = selectedGUID
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case taskTitleTextField:
            textField.resignFirstResponder()
            self.taskTeamTextField.becomeFirstResponder()
            break
        case taskTeamTextField:
            textField.resignFirstResponder()
            self.taskDescriptionTextView.becomeFirstResponder()
            break
        case taskDescriptionTextView:
            textField.resignFirstResponder()
            self.createTaskPressed(self)
            break
        default:
            textField.resignFirstResponder()
            break
        }
        
        return false
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            self.createTaskPressed(self)
            return false
        }
        return true
    }
        
    @IBAction func teamSelectionEditingPressed(_ sender: Any) {
        Logger.log("Team selection textbox pressed")
        self.view.endEditing(true)
        FirebaseUtilities.fetchAllTeamGUIDs(callback: {
            [weak self] (teams: [String]) in
            guard let this = self else { return }
            this.performSegue(withIdentifier: "CreateTaskSelectTeamSegue", sender: teams)
        })
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    @IBAction func createTaskPressed(_ sender: Any) {
        Logger.log("Create Task button pressed.")
        
        let title = self.taskTitleTextField.text ?? ""
        let priority = Globals.TaskGlobals.DEFAULT_PRIORITY
        let desc = self.taskDescriptionTextView.text ?? ""
        let status = Globals.TaskGlobals.DEFAULT_STATUS
        let teamGUID = self.taskTeamTextField.text ?? Globals.TaskGlobals.DEFAULT_TEAM
        
        if title == "" {
            self.displayAlert(title: "Title Error", message: "Tasks require titles.")
            return
        }
        
        if desc == "" {
            self.displayAlert(title: "Description Error", message: "Tasks need a description.")
            return
        }
        
        if teamGUID == "" || teamGUID == Globals.TeamGlobals.DEFAULT_GUID {
            self.displayAlert(title: "Team Name Error", message: "Tasks need teams.")
            return
        }
        
        if let user = user {
            if user.getUUID() == Globals.UserGlobals.DEFAULT_UUID {
                self.displayAlert(title: "Error Fetching User", message: "An unknown erorr occured when attempting to fetch the UUID.")
            } else {
                let task = Task(uuid: user.getUUID(), guid: teamGUID, title: title, priority: priority, description: desc, status: status)
                
                Logger.log("Task created successfully, performing nav unwind segue")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
            Logger.log("You've pressed OK button");
        }
        
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    @IBAction func unwindToCreateTaskView(segue: UIStoryboardSegue) { }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateTaskSelectTeamSegue" {
            if let dest = segue.destination as? CreateTaskSelectTeamTableViewController {
                if let teams = sender as? [String] {
                    Logger.log("CreateTaskSelectTeamSegue called")
                    dest.teams = teams
                }
            }
        }
    }
}
