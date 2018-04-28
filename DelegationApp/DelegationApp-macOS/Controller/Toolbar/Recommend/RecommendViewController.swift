//
//  RecommendViewController.swift
//  DelegationApp-macOS
//
//  Created by Erik Phillips on 4/26/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import Cocoa

class RecommendViewController: NSViewController {

    private var currTargetUUID: String? = "Kd8p3fl5xyPT0g9BGkHASF025D23"
    private var rec: Recomendation?
    
    @IBOutlet var console: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func addConsoleMessage(_ msg: String) {
        Logger.log(msg)
        self.console.string += msg + "\n"
        self.console.scrollToEndOfDocument(nil)
    }
    
    
    @IBAction func loadDataBtnPressed(_ sender: Any) {
        addConsoleMessage("INFO: Load button pressed")
        
        guard let currTargetUUID = self.currTargetUUID else {
            addConsoleMessage("ERROR: Unable to gather target UUID")
            return
        }
        
        self.rec = Recomendation(targetUUID: currTargetUUID)
        self.rec?.setupCallback = {
            [weak self] in
            guard let this = self else { return }
            this.addConsoleMessage("INFO: Load completed - (\(this.rec?.getInfoString() ?? "nil"))")
        }
    }
    
    @IBAction func computeKeywords(_ sender: Any) {
        addConsoleMessage("INFO: Compute keywords button pressed")
        if let rec = self.rec {
            rec.generateKeywords {
                [weak self] in
                guard let this = self else { return }
                this.addConsoleMessage("Keywords generated.")
            }
        }
    }
    
    @IBAction func getPredsBtnPressed(_ sender: Any) {
        addConsoleMessage("INFO: Get predictions button pressed")
        
        if let rec = self.rec {
            rec.getPredictedTasks(callback: {
                [weak self] (pred_tasks) in
                guard let this = self else { return }
                this.addConsoleMessage("Predictions completed: \(pred_tasks.count) tasks found.")
                for t in pred_tasks {
                    this.addConsoleMessage("\t" + t)
                }
            })
        } else {
            addConsoleMessage("ERROR: No recommendation system initialized.")
            addConsoleMessage("INFO: Load the recommendation system before getting predictions.")
        }
    }
    
}
