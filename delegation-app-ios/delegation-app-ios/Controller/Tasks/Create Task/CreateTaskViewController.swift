//
//  CreateTaskViewController.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/29/17.
//  Copyright © 2017-2018 Erik Phillips. All rights reserved.
//

import UIKit

class CreateTaskViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    var user: User?
    var selectedGUID: String?
    
    @IBOutlet weak var taskTitleTextField: UITextField!
    @IBOutlet weak var taskDescriptionTextView: UITextView!
    @IBOutlet weak var taskTeamTextField: UITextField!
    
//    @IBOutlet weak var taskPriorityValueTextField: UILabel!
//    @IBAction func priorityChangerPressed(_ sender: UIStepper) {
//        Logger.log("Stepper changed value to \(Int(sender.value))")
//        self.taskPriorityValueTextField.text = String(Int(sender.value))
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
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
                
                task.observers.observe(canary: self, callback: {
                    [weak self] (task: Task) in
                    guard let this = self else { return }
                    
                    Logger.log("Task created successfully, performing nav unwind segue")
                    this.navigationController?.popViewController(animated: true)
                })
            }
        }
        
        // TODO: Fix this to work with the new API
//        if let user = user {
//            if user.getUUID() == Globals.UserGlobals.DEFAULT_UUID {
//                self.displayAlert(title: "Error Fetching User", message: "An unknown erorr occured when attempting to fetch the UUID.")
//            } else {
//                let task = Task(title: title, priority: priority, description: desc, team: teamUUID, status: status, resolution: resolution, assigneeUUID: user.getUUID(), originatorUUID: user.getUUID())
//                FirebaseUtilities.createTask(task)
//
//                self.navigationController?.popViewController(animated: true)
//            }
//        } else {
//            self.displayAlert(title: "Invalid User", message: "Unable to get a user object.")
//        }
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
