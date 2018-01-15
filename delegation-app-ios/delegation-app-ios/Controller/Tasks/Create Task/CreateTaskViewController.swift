//
//  CreateTaskViewController.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/29/17.
//  Copyright © 2017-2018 Erik Phillips. All rights reserved.
//

import UIKit

class CreateTaskViewController: UIViewController, UIPopoverPresentationControllerDelegate {

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
        let desc = self.taskDescriptionTextView.text ?? ""
        let status = Globals.Task.DEFAULT_STATUS
        let teamName = self.taskTeamTextField.text ?? ""
        
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
        
        // TODO: Create the task in the database
        self.navigationController?.popViewController(animated: true)
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
