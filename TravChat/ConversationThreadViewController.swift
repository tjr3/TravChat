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
        
        self.messages.sortInPlace { $0.timestamp.timeIntervalSince1970 < $1.timestamp.timeIntervalSince1970 }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ConversationThreadViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ConversationThreadViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: self.view.window)
        
        scrollToBottomOfTableView()
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
    }
    
    // MARK: - Keyboard -

    func keyboardWillHide(sender: NSNotification) {
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        self.view.frame.origin.y += keyboardSize.height
    }

    func keyboardWillShow(sender: NSNotification) {
        let userInfo: [NSObject : AnyObject] = sender.userInfo!
        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
        let offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
        
        if keyboardSize.height == offset.height {
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.view.frame.origin.y -= keyboardSize.height
            })
        } else {
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.view.frame.origin.y += keyboardSize.height - offset.height
            })
        }
    }
    
    func scrollToBottomOfTableView() {
        let numberOfSections = conversationTableView.numberOfSections
        let numberOfRows = conversationTableView.numberOfRowsInSection(numberOfSections-1)
        
        let indexPath = NSIndexPath(forRow: numberOfRows - 1, inSection: numberOfSections - 1)
        conversationTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
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
            let message = messageTextField.text where message.characters.count > 0 {
            if let thread = thread, let displayName = user.displayName {
                ThreadController.sharedController.addMessageToThread(message, thread: thread, displayName: displayName, completion: { (message) in
                    self.messages.append(message)
                    self.messages.sortInPlace { $0.timestamp.timeIntervalSince1970 < $1.timestamp.timeIntervalSince1970 }
                    self.conversationTableView.reloadData()
                    self.scrollToBottomOfTableView()
                    self.messageTextField.text = ""
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
