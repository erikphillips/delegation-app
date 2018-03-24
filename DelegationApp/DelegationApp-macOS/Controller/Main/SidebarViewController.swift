//
//  SidebarViewController.swift
//  DelegationApp-macOS
//
//  Created by Erik Phillips on 3/15/18.
//  Copyright © 2018 Erik Phillips. All rights reserved.
//

import Cocoa

class SidebarViewController: NSViewController, NSOutlineViewDataSource, NSOutlineViewDelegate {

    var user: User?
    
    @IBOutlet weak var outlineView: NSOutlineView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Logger.log("SidebarViewController viewDidLoad")
        
        self.outlineView.delegate = self
        self.outlineView.dataSource = self
    }
    
    override func viewWillAppear() {
        Logger.log("SidebarViewController viewWillAppear")
        Logger.log("SidebarViewController will appear with user=\(self.user?.getUUID() ?? "nil")")
        
        if let user = self.user {
            user.observers.observe(canary: self, callback: { [weak self] (user) in
                guard let this = self else { return }
                Logger.log("refreshing outline due to user update")
                this.refresh()
            })
        }
        
        self.refresh()
    }
    
    func refresh() {
        Logger.log("refreshing outline view data...")
        self.outlineView.reloadData()
    }
    
    // Notification called whenever the selection changes in the outline view
    func outlineViewSelectionDidChange(_ notification: Notification) {
        Logger.log("SideBar outline view selection changed to=\(self.outlineView.selectedRow)")
        
        if let item = outlineView.item(atRow: self.outlineView.selectedRow) as? (String, Int) {
            Logger.log("selected item=\(item), posting notification if applicable")
            
            if item.0 == self.headers[0] {
                NotificationCenter.default.post(name: ObservableNotifications.NOTIFICATION_ALL_TEAM_SELECTION, object: nil)
            } else if item.0 == "specific_team" {
                if let team = self.user?.getTeams()[item.1] {
                    NotificationCenter.default.post(name: ObservableNotifications.NOTIFICATION_TEAM_SELECTION, object: nil, userInfo: ["teamname": team.getGUID(), "team": team])
                }
            }
        }
    }
    
    let headers = ["All Teams", "Specific Teams"]
    
    // You must give each row a unique identifier, referred to as `item` by the outline view
    // item == nil means it's the "root" row of the outline view, which is not visible
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if item == nil {
            return (self.headers[index], index)
        } else if let item = item as? (String, Int), item.0 == self.headers[0] {
            return ("all_teams", index)
        } else if let item = item as? (String, Int), item.0 == self.headers[1] {
            return ("specific_team", index)
        } else {
            return ("other", index)
        }
    }
    
    // Tell how many children each row has.
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if item == nil {
            return self.headers.count
        } else if let item = item as? (String, Int), item.0 == self.headers[1] {
            return self.user?.getTeams().count ?? 0
        } else {
            return 0
        }
    }
    
    // Return True whether the row is expandable and False otherwise.
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let item = item as? (String, Int), item.0 == self.headers[1] {
            return true
        } else {
            return false
        }
    }
    
    // Return true if the row is selectable
    func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
        if let item = item as? (String, Int), item.0 == self.headers[1] {
            return false  // the only row that should not be selected is the Specific Teams header cell
        } else {
            return true
        }
    }
    
    // Set the cell contents for each row and item
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        if let item = item as? (String, Int), item.0 == self.headers[0] {
            let cell = self.outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "OutlineTeamDataCell"), owner: self) as! NSTableCellView
            cell.textField?.stringValue = "All Teams"
            return cell
        } else if let item = item as? (String, Int), item.0 == self.headers[1] {
            let cell = self.outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "OutlineHeaderCell"), owner: self) as! NSTableCellView
            cell.textField?.stringValue = "Specific Teams"
            return cell
        } else if let item = item as? (String, Int), item.0 == "specific_team" {
            if let teams = self.user?.getTeams() {
                let cell = self.outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "OutlineTeamDataCell"), owner: self) as! NSTableCellView
                cell.textField?.stringValue = teams[item.1].getGUID()
                return cell
            }
        }
        
        let cell = self.outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "OutlineHeaderCell"), owner: self) as! NSTableCellView
        cell.textField?.stringValue = "<error>"
        return cell
    }
}
