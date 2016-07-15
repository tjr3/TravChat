//
//  ConversationThreadViewController.swift
//  TravChat
//
//  Created by Tyler on 6/29/16.
//  Copyright © 2016 Tyler. All rights reserved.
//

import UIKit

class ConversationThreadViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ConversationTableViewCellDelegate {
    
    var conversationRegion: Region?
    var thread: Thread?
    var messages: [Message] = []
    
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var conversationTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let region = conversationRegion else { return }
        self.title = region.name
        
        for thread in ThreadController.sharedController.threads {
            if thread.name == region.name {
                self.thread = thread
            }
        }
        for message in (thread?.messages)! {
            messages.append(message as! Message)
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            } else {
            }
        }
    }
    
    func keyboardWillHide(notificaiton: NSNotification) {
     
        if let keyboardSize = (notificaiton.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            } else {
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Action Buttons -
    
    @IBAction func nameTapped(sender: AnyObject) {
        presentAlertController()
        
        //        TODO: if cancel { dismissViewController },
        //        if report { report },
        //        else (segue if DM is selected) { return segue with identifier }.
        //        performSegueWithIdentifier("toPrivateChat", sender: self)
    }
    
    @IBAction func sendButtonTapped(sender: AnyObject) {
        if let user = UserController.sharedController.currentUser,
            let message = messageTextField.text {
            if let thread = thread, let displayName = user.displayName {
                ThreadController.sharedController.addMessageToThread(message, thread: thread, displayName: displayName, completion: { (success) in
                    
                    if success == true {
                        self.conversationTableView.reloadData()
                    }
                })
            }
        }
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("messageCell", forIndexPath: indexPath) as! ConversationThreadTableViewCell
        cell.delegate = self
        
        let message = messages[indexPath.row]
        cell.displayNameLabel.text = message.displayName ?? ""
        cell.timeLabel.text = message.timestamp.dateFormat()
        cell.messageLabel.text = message.message
        
        return cell
    }
    
    func presentAlertController() {
        let actionSheet = UIAlertController(title: "\(UserInformation.displayNameKey)", message: "What would you like to do?", preferredStyle: .ActionSheet)
        
        let directMessageAction = UIAlertAction(title: "Direct Message", style: .Default, handler: nil) // Add code in the handler to set button functionalility
        let reportAction = UIAlertAction(title: "Report", style: .Destructive, handler: nil) // Add code in the handler to set button functionalility
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        actionSheet.addAction(directMessageAction)
        actionSheet.addAction(reportAction)
        actionSheet.addAction(cancelAction)
        
        presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: - ConversationTableViewCellDelegate -
    
    func nameButtonTapped(cell: ConversationThreadTableViewCell) {
        print(conversationTableView.indexPathForCell(cell))
        presentAlertController()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
