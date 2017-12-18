//
//  UtilitiesViewController.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/18/17.
//  Copyright © 2017 Erik Phillips. All rights reserved.
//

import UIKit
import Firebase

class UtilitiesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func fetchAllUsersPressed(_ sender: Any) {
        
    }
    
    @IBAction func fetchTestDataPressed(_ sender: Any) {
        print("Fetch Test Data Button Pressed...")
        let ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("test").observeSingleEvent(of: .value, with: {
            (snapshot) in
            print(snapshot)
        })
    }
    
    @IBAction func activeListenerPressed(_ sender: Any) {
        let ref: DatabaseReference!
        ref = Database.database().reference().child("test")
        
        print("Active listener pressed...")
        let refHandle = ref.observe(DataEventType.value, with: { (snapshot) in
            print(snapshot)
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            print(postDict)
        })
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
