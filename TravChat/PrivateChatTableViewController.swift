//
//  PrivateChatTableViewController.swift
//  TravChat
//
//  Created by Tyler on 6/29/16.
//  Copyright © 2016 Tyler. All rights reserved.
//

import UIKit

class PrivateChatTableViewController: UITableViewController {
    
    var messages: [Message] = []
    var user: UserInformation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        //        self.users.sortInPlace { $0.timestamp.timeIntervalSince1970 < $1.timestamp.timeIntervalSince1970 }
    }
    
    func configureView() {
        
        if let navBar = UIFont(name: "PingFangHK-Thin", size: 28.0) {
            let navBarAttributesDicitonary: [NSObject: AnyObject]? = [
                NSForegroundColorAttributeName: UIColor.blackColor(),
                NSFontAttributeName: navBar
            ]
            
            guard let altributeDict = navBarAttributesDicitonary as? [String: AnyObject] else { return }
            navigationController?.navigationBar.titleTextAttributes = altributeDict
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ThreadController.sharedController.oneToOneThreads?.count ?? 0
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("privateChatCell", forIndexPath: indexPath) as? PrivateChatTableViewCell
        if let thread = ThreadController.sharedController.oneToOneThreads?[indexPath.row] {
            cell?.updateWith(thread)
        }
        
        return cell ?? UITableViewCell()
    }
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toPrivateChatSegue" {
            let privateThreadVC = segue.destinationViewController as? PrivateChatConversationThreadViewController
            if let selectedIndexPath = self.tableView.indexPathForSelectedRow?.row {
                if let pcThread = ThreadController.sharedController.oneToOneThreads?[selectedIndexPath], let messages = pcThread.messages?.allObjects as? [Message] {
                    privateThreadVC?.messages = messages
                }
            }
        }
    }
}
