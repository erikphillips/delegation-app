//
//  CreateTaskViewController.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/29/17.
//  Copyright © 2017 Erik Phillips. All rights reserved.
//

import UIKit

class CreateTaskViewController: UIViewController {

    @IBOutlet weak var taskTitleTextField: UITextField!
    @IBOutlet weak var taskDescriptionTextView: UITextView!
    @IBOutlet weak var taskStateTextField: UITextField!
    @IBOutlet weak var taskTeamTextField: UITextField!
    
    @IBOutlet weak var taskTeamPicker: UIPickerView!
    @IBOutlet weak var taskStatePicker: UIPickerView!
    
    @IBOutlet weak var taskPriorityValueTextField: UILabel!
    @IBAction func priorityChangerPressed(_ sender: UIStepper) {
        print("Stepper changed value to \(Int(sender.value))")
        self.taskPriorityValueTextField.text = String(Int(sender.value))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.taskPriorityValueTextField.text = "5"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func createTaskPressed(_ sender: Any) {
        let title = self.taskTitleTextField.text ?? ""
        let desc = self.taskDescriptionTextView.text ?? ""
        let state = self.taskStateTextField.text ?? ""
        let teamName = self.taskStateTextField.text ?? ""
        
        if title == "" {
            self.displayAlert(title: "Title Error", message: "Tasks require titles.")
            return
        }
        
        if desc == "" {
            self.displayAlert(title: "Description Error", message: "Tasks need a description.")
            return
        }
        
        if state == "" {
            self.displayAlert(title: "State Error", message: "Tasks need states.")
        }
        
        if teamName == "" {
            self.displayAlert(title: "Team Name Erorr", message: "Tasks need teams.")
        }
        
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
