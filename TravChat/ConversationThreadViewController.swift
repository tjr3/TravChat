//
//  ConversationThreadViewController.swift
//  TravChat
//
//  Created by Tyler on 6/29/16.
//  Copyright © 2016 Tyler. All rights reserved.
//

import UIKit

class ConversationThreadViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ConversationTableViewCellDelegate, SenderConversationThreadCellDelegate {
    
    var conversationRegion: Region?
    var thread: Thread?
    var messages: [Message] = []
    var keyboardShown = false
    
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var conversationTableView: UITableView!
    @IBOutlet weak var messageStackView: UIStackView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dynamicTableViewCellHeight()
        
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide), name:UIKeyboardWillHideNotification, object: nil)
        
        scrollToBottomOfTableView()
    }
    
    // MARK: - Keyboard/TextView -
    
    func keyboardWillShow(sender: NSNotification) {
        if !keyboardShown {
            if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                UIView.animateWithDuration(3.0, animations: {
                    self.bottomConstraint.constant += keyboardSize.height - 50
                    self.view.layoutIfNeeded()
                })
            }
            keyboardShown = true
        }
    }
    
    func keyboardWillHide(sender: NSNotification) {
        if keyboardShown {
            bottomConstraint.constant = 0
            keyboardShown = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        messageTextView.setContentOffset(CGPoint.zero, animated: false)
        messageTextView.contentInset = UIEdgeInsetsZero
    }
    
    // MARK: - Table view positioning -
    
    func scrollToBottomOfTableView() {
        let numberOfSections = conversationTableView.numberOfSections
        let numberOfRows = conversationTableView.numberOfRowsInSection(numberOfSections-1)
        
        let indexPath = NSIndexPath(forRow: numberOfRows - 1, inSection: numberOfSections - 1)
        conversationTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
    }
    
    func dynamicTableViewCellHeight() {
        conversationTableView.rowHeight = UITableViewAutomaticDimension
        conversationTableView.estimatedRowHeight = 75
    }
    
    
    // MARK: - Action Buttons -
    
    @IBAction func nameTapped(sender: AnyObject) {
        presentAlertController()
        
    }
    
    @IBAction func sendButtonTapped(sender: AnyObject) {
        if let user = UserController.sharedController.currentUser,
            let message = messageTextView.text where message.characters.count > 0 {
            if let thread = thread, let displayName = user.displayName {
                ThreadController.sharedController.addMessageToThread(message, user: user, thread: thread, displayName: displayName, completion: { (message) in
                    self.messages.append(message)
                    self.messages.sortInPlace { $0.timestamp.timeIntervalSince1970 < $1.timestamp.timeIntervalSince1970 }
                    self.conversationTableView.reloadData()
                    self.scrollToBottomOfTableView()
                    self.messageTextView.text = ""
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
        let message = messages[indexPath.row]
        
        if message.displayName == UserController.sharedController.currentUser?.displayName{
            let senderCell = tableView.dequeueReusableCellWithIdentifier("senderCell", forIndexPath: indexPath) as! SenderConversationThreadCell
            senderCell.delegate = self
            
            let senderMessage = messages[indexPath.row]
            senderCell.cuDisplayNameLabel.text = senderMessage.displayName ?? ""
            senderCell.cuTimeLabel.text = senderMessage.timestamp.secondaryDateFormat()
            senderCell.cuMessageLabel.text = senderMessage.message
            
            return senderCell
            
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("messageCell", forIndexPath: indexPath) as! ConversationThreadTableViewCell
            cell.delegate = self
            
            cell.displayNameLabel.text = message.displayName ?? ""
            cell.timeLabel.text = message.timestamp.dateFormat()
            cell.messageLabel.text = message.message
            
            
            return cell
        }
        
    }
    
    func presentAlertController() {
        let actionSheet = UIAlertController(title: "\(UserInformation.displayNameKey)", message: "What would you like to do?", preferredStyle: .ActionSheet)
        let directMessageAction = UIAlertAction(title: "Direct Message", style: .Default) { (_) in
            self.performSegueWithIdentifier("threadToPrivateChat", sender: self)
        }
        let reportAction = UIAlertAction(title: "Report", style: .Destructive, handler: nil) // Add code in the handler to set button functionalility
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        actionSheet.addAction(directMessageAction)
        actionSheet.addAction(reportAction)
        actionSheet.addAction(cancelAction)
        
        presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: - ConversationTableViewCellDelegates -
    
    func messageCell(cell: ConversationThreadTableViewCell) {
        print(conversationTableView.indexPathForCell(cell))
        presentAlertController()
    }
    
    func senderCell(cell: SenderConversationThreadCell) {
        print(conversationTableView.indexPathForCell(cell))
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "threadToPrivateChat", let indexPath = conversationTableView.indexPathForSelectedRow, privateChatTVC = segue.destinationViewController as? PrivateChatTableViewController {
            if let user = messages[indexPath.row].user {
                privateChatTVC.user = user
            }
        }
    }
}
