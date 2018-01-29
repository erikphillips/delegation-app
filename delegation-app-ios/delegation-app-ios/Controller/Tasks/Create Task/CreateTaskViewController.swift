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
    
    @IBOutlet weak var taskTitleTextField: UITextField!
    @IBOutlet weak var taskDescriptionTextView: UITextView!
    @IBOutlet weak var taskTeamTextField: UITextField!
    
//    @IBOutlet weak var taskPriorityValueTextField: UILabel!
//    @IBAction func priorityChangerPressed(_ sender: UIStepper) {
//        print("Stepper changed value to \(Int(sender.value))")
//        self.taskPriorityValueTextField.text = String(Int(sender.value))
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func teamSelectionEditingPressed(_ sender: Any) {
        print("selected team textbox pressed")
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    @IBAction func createTaskPressed(_ sender: Any) {
        let title = self.taskTitleTextField.text ?? ""
        let priority = Globals.TaskGlobals.DEFAULT_PRIORITY
        let desc = self.taskDescriptionTextView.text ?? ""
        let status = Globals.TaskGlobals.DEFAULT_STATUS
//        let teamName = self.taskTeamTextField.text ?? ""
        let teamUUID = "-L16CsxYegfD0P3yix29"
        
        if title == "" {
            self.displayAlert(title: "Title Error", message: "Tasks require titles.")
            return
        }
        
        if desc == "" {
            self.displayAlert(title: "Description Error", message: "Tasks need a description.")
            return
        }
        
//        if teamName == "" {
//            self.displayAlert(title: "Team Name Error", message: "Tasks need teams.")
//            return
//        }
        
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
            print("You've pressed OK button");
        }
        
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion:nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
