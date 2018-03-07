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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Logger.log("LaunchViewController viewDidLoad")

        // Do any additional setup after loading the view.
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func loadPressed(_ sender: Any) {
        print("Button Pressed")
        self.user = User(uuid: "Kd8p3fl5xyPT0g9BGkHASF025D23")
        user?.setupCallback = {
            [weak self] in
            guard let this = self else { return }
            print(this.user?.toString() ?? "Error")
        }
    }

}

