//
//  TeamSpecificTaskDetailViewController.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 2/22/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import UIKit

class TeamSpecificTaskDetailViewController: UITableViewController {

    var user: User?
    var task: Task?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var assigneeLabel: UILabel!
    @IBOutlet weak var originatorLabel: UILabel!
    @IBOutlet weak var teamLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let task = self.task {
            self.titleLabel.text = task.getTitle()
            self.statusLabel.text = task.getStatus()
            self.priorityLabel.text = task.getPriority()
            self.assigneeLabel.text = task.getAssigneeUUID()
            self.originatorLabel.text = task.getOriginatorUUID()
            self.teamLabel.text = task.getTeamUID()
            self.descriptionTextView.text = task.getDescription()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
