//
//  ViewController.swift
//  macOSDelegationApp
//
//  Created by Erik Phillips on 3/5/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import Cocoa

class LaunchViewController: NSViewController {
    
    var user: User?

    @IBOutlet weak var emailAddressTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSSecureTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Logger.log("LaunchViewController viewDidLoad")
        
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        Logger.log("loginButtonPressed, show main segue called")
        self.performSegue(withIdentifier: NSStoryboardSegue.Identifier("ShowMainViewSegue"), sender: nil)
        self.view.window?.close()
    }
    
    @IBAction func loadPressed(_ sender: Any) {
        print("Button Pressed")
        self.user = User(uuid: "Kd8p3fl5xyPT0g9BGkHASF025D23")
        self.user?.setupCallback = {
            [weak self] in
            guard let this = self else { return }
            Logger.log(this.user?.toString() ?? "Error")
        }
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier?.rawValue == "CreateNewAccountSegue" {
            if let dest = segue.destinationController as? CreateAccountViewController {
                Logger.log("CreateNewAccountSegue called")
                dest.loginDictionary = ["email": self.emailAddressTextField.stringValue,
                                        "password": self.passwordTextField.stringValue]
            }
        }
    }

}

