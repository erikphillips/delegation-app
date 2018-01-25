//
//  UtilitiesViewController.swift
//  delegation-app-ios
//
//  Created by Erik Phillips on 12/18/17.
//  Copyright © 2017-2018 Erik Phillips. All rights reserved.
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
        print("Fetch all users pressed...")
//        FirebaseUtilities.getUserInformation(uid: "Kd8p3fl5xyPT0g9BGkHASF025D23", callback: {
//            (user, error) in
//            if let user = user {
//                print(user.getFullName())
//            } else if let error = error {
//                print(error.localizedDescription)
//            } else {
//                print("fetchAllUsersPressed: Found unknown error.")
//            }
//
//        })
    }
    
    class CustomUser {
        public var firstname: String = ""
        public var lastname: String = ""
        
        init(uuid: String) {
            var ref: DatabaseReference!
            ref = Database.database().reference().child("users/\(uuid)/information/")
            ref.observe(DataEventType.value, with: {
                [weak self] (snapshot) in
                guard let this = self else { return }
                
                let value = snapshot.value as? NSDictionary
                this.firstname = value?["firstname"] as? String ?? Globals.User.DEFAULT_FIRSTNAME
                this.lastname = value?["lastname"] as? String ?? Globals.User.DEFAULT_LASTNAME
                
                print("Values were updated.")
                print(this.firstname)
                print(this.lastname)
            })
        }
    }
    
    @IBOutlet weak var firstnameLabel: UILabel!
    @IBOutlet weak var lastnameLabel: UILabel!
    @IBAction func refreshPressed(_ sender: Any) {
        self.firstnameLabel.text = self.user?.firstname ?? ""
        self.lastnameLabel.text = self.user?.lastname ?? ""
    }
    
    var user: CustomUser? = nil
    
    @IBAction func loadObservableUserPressed(_ sender: Any) {
        let uuid = "Kd8p3fl5xyPT0g9BGkHASF025D23"
        
        self.user = CustomUser(uuid: uuid)
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

}
