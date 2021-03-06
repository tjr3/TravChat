//
//  PrivateChatConversationThreadViewController.swift
//  TravChat
//
//  Created by Tyler on 7/19/16.
//  Copyright © 2016 Tyler. All rights reserved.
//

import UIKit
import QuartzCore

class PrivateChatConversationThreadViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ConversationTableViewCellDelegate, SenderConversationThreadCellDelegate {
    
    var user: UserInformation?
    var messages: [Message] = []
    var thread: Thread?
    var keyboardShown = false
    
    @IBOutlet weak var pcMessageTextView: UITextView!
    @IBOutlet weak var pcConversationTableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dynamicTableViewCellHeight()
        
        if let user = user {
            self.title = user.displayName
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
        pcMessageTextView.setContentOffset(CGPoint.zero, animated: false)
        pcMessageTextView.contentInset = UIEdgeInsetsZero
    }
    
    // MARK: - Table view positioning -
    
    func scrollToBottomOfTableView() {
        guard pcConversationTableView.numberOfSections > 0 else {
            return
        }
        let numberOfSections = pcConversationTableView.numberOfSections
        let numberOfRows = pcConversationTableView.numberOfRowsInSection(numberOfSections-1)
        
        let indexPath = NSIndexPath(forRow: numberOfRows - 1, inSection: numberOfSections - 1)
        guard indexPath.row >= 0 else {
            return
        }
        pcConversationTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
    }
    
    func dynamicTableViewCellHeight() {
        pcConversationTableView.rowHeight = UITableViewAutomaticDimension
        pcConversationTableView.estimatedRowHeight = 75
    }
    
    // MARK: - Action Buttons
    
    @IBAction func sendButtonTapped(sender: AnyObject) {
        if let user = UserController.sharedController.currentUser,
            let message = pcMessageTextView.text where message.characters.count > 0 {
            if let thread = thread,
                let displayName = user.displayName {
                ThreadController.sharedController.addMessageToThread(message, user: user, thread: thread, displayName: displayName, completion: { (message) in
                    self.messages.append(message)
                    self.messages.sortInPlace { $0.timestamp.timeIntervalSince1970 < $1.timestamp.timeIntervalSince1970 }
                    self.pcConversationTableView.reloadData()
                    self.scrollToBottomOfTableView()
                    self.pcMessageTextView.text = ""
                    self.pcConversationTableView.reloadData()
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
            let senderCell = tableView.dequeueReusableCellWithIdentifier("pcSenderCell", forIndexPath: indexPath) as! SenderConversationThreadCell
            senderCell.delegate = self
            
            let senderMessage = messages[indexPath.row]
            senderCell.cuDisplayNameLabel.text = senderMessage.displayName ?? ""
            senderCell.cuTimeLabel.text = senderMessage.timestamp.secondaryDateFormat()
            senderCell.cuMessageLabel.text = senderMessage.message
            
            return senderCell
            
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("pcMessageCell", forIndexPath: indexPath) as! ConversationThreadTableViewCell
            cell.delegate = self
            
            cell.displayNameLabel.text = message.displayName ?? ""
            cell.timeLabel.text = message.timestamp.dateFormat()
            cell.messageLabel.text = message.message
            
            return cell
        }
    }
    
    
    // MARK: - PrivateConversationTableViewCellDelegates -
    
    func messageCell(cell: ConversationThreadTableViewCell) {
        print(pcConversationTableView.indexPathForCell(cell))
    }
    
    func senderCell(cell: SenderConversationThreadCell) {
        print(pcConversationTableView.indexPathForCell(cell))
    }
    
}
