//
//  PrivateChatConversationThreadViewController.swift
//  TravChat
//
//  Created by Tyler on 7/19/16.
//  Copyright © 2016 Tyler. All rights reserved.
//

import UIKit

class PrivateChatConversationThreadViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ConversationTableViewCellDelegate, SenderConversationThreadCellDelegate {
    
    var conversationUser: UserInformation?
    var messages: [Message] = []
    var thread: Thread?
     
    
    @IBOutlet weak var pcMessageTextField: UITextField!
    @IBOutlet weak var pcConversationTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let user = conversationUser else { return }
        self.title = user.displayName
        
        for message in (thread?.messages)! {
            messages.append(message as! Message)
        }
        
        self.messages.sortInPlace { $0.timestamp.timeIntervalSince1970 < $1.timestamp.timeIntervalSince1970 }
        
        scrollToBottomOfTableView()
    }

    func scrollToBottomOfTableView() {
        let numberOfSections = pcConversationTableView.numberOfSections
        let numberOfRows = pcConversationTableView.numberOfRowsInSection(numberOfSections-1)
        
        let indexPath = NSIndexPath(forRow: numberOfRows - 1, inSection: numberOfSections - 1)
        pcConversationTableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
    }

    
    // MARK: - Action Buttons
    
    @IBAction func sendButtonTapped(sender: AnyObject) {
        if let user = UserController.sharedController.currentUser,
            let message = pcMessageTextField.text where message.characters.count > 0 {
            if let thread = thread, let displayName = user.displayName {
                ThreadController.sharedController.addMessageToThread(message, thread: thread, displayName: displayName, completion: { (message) in
                    self.messages.append(message)
                    self.messages.sortInPlace { $0.timestamp.timeIntervalSince1970 < $1.timestamp.timeIntervalSince1970 }
                    self.pcConversationTableView.reloadData()
                    self.scrollToBottomOfTableView()
                    self.pcMessageTextField.text = ""
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
