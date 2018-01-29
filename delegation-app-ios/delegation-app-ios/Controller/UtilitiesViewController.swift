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

        self.user.userUpdatedHandler = {
            [weak self] in
            guard let this = self else { return }
            
            Logger.log("Controller completion handled")
            this.firstnameLabel.text = this.user.firstname
            this.lastnameLabel.text = this.user.lastname
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func fetchAllUsersPressed(_ sender: Any) {
        Logger.log("Fetch all users pressed...")
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
        
        var userUpdatedHandler: (() -> Void)?
        
        init() {}
        
        init(uuid: String) {
            var ref: DatabaseReference!
            ref = Database.database().reference().child("users/\(uuid)/information/")
            
            ref.observe(DataEventType.value, with: {
                [weak self] (snapshot) in
                guard let this = self else { return }
                
                let value = snapshot.value as? NSDictionary
                this.firstname = value?["firstname"] as? String ?? Globals.UserGlobals.DEFAULT_FIRSTNAME
                this.lastname = value?["lastname"] as? String ?? Globals.UserGlobals.DEFAULT_LASTNAME
                
                Logger.log("Values were updated.")
                Logger.log(this.firstname)
                Logger.log(this.lastname)
                
                // If the userUpdateHandler is only needed once, then set it to nil
//                this.userUpdatedHandler = nil
            })
        }
    }
    
    @IBOutlet weak var firstnameLabel: UILabel!
    @IBOutlet weak var lastnameLabel: UILabel!
    @IBAction func refreshPressed(_ sender: Any) {
        self.firstnameLabel.text = self.user.firstname
        self.lastnameLabel.text = self.user.lastname
    }
    
    var user: CustomUser = CustomUser()
    
    @IBAction func loadObservableUserPressed(_ sender: Any) {
        let uuid = "Kd8p3fl5xyPT0g9BGkHASF025D23"
        
        self.user = CustomUser(uuid: uuid)
    }
    
    @IBAction func fetchTestDataPressed(_ sender: Any) {
        Logger.log("Fetch Test Data Button Pressed...")
        let ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("test").observeSingleEvent(of: .value, with: {
            (snapshot) in
            Logger.log(String(describing: snapshot))
        })
    }
    
    @IBAction func activeListenerPressed(_ sender: Any) {
        let ref: DatabaseReference!
        ref = Database.database().reference().child("test")
        
        Logger.log("Active listener pressed...")
        let refHandle = ref.observe(DataEventType.value, with: { (snapshot) in
            Logger.log(String(describing: snapshot))
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            Logger.log(String(describing: postDict))
        })
    }

}
