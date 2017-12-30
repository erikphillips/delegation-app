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
    
    @IBAction func priorityChangerPressed(_ sender: Any) {
        print("Stepper changed value")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
