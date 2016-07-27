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
    var thread: Thread?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
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
    
//    func filterTableView() {
//        if let user = UserInformation {
//            let userArray = user as? [UserInformation] ?? {
//                userArray?.sort() { $0.displayName > $1.displayName}
//                tableView.reloadData()
//            }
//        }
//    }
    
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toPrivateChatSegue" {
            let privateThreadVC = segue.destinationViewController as? PrivateChatConversationThreadViewController
            if let selectedIndexPath = self.tableView.indexPathForSelectedRow?.row {
                if let pcThread = ThreadController.sharedController.oneToOneThreads?[selectedIndexPath], let messages = pcThread.messages?.allObjects as? [Message], let usersSet = pcThread.userInformations, let currentUser = UserController.sharedController.currentUser, let users = usersSet.allObjects as? [UserInformation] {
                    let user = users.filter { $0 != currentUser }.first
                    if let user = user {
                        privateThreadVC?.user = user
                    }
                    print(currentUser)
                    privateThreadVC?.messages = messages
                    privateThreadVC?.thread = pcThread
                }
            }
        }
    }
}
