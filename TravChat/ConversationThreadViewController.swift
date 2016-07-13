//
//  ConversationThreadViewController.swift
//  TravChat
//
//  Created by Tyler on 6/29/16.
//  Copyright © 2016 Tyler. All rights reserved.
//

import UIKit

class ConversationThreadViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var conversationRegion: Region?
    var thread: Thread?
    var messages: [Message] = []
    
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var conversationTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let region = conversationRegion else { return }
        self.title = region.name
        thread = Thread(name: "Africa")
        let firstMessage = Message(thread: thread!, message: "I love France.", displayName: "Alan", timestamp: NSDate())
        thread = Thread(name: "Asia")
        let secondMessage = Message(thread: thread!, message: "Go To Sendai!", displayName: "ty Rob", timestamp: NSDate())
        messages.append(firstMessage)
        messages.append(secondMessage)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Action Buttons -
    
    @IBAction func sendButtonTapped(sender: AnyObject) {
        
//    guard let messageText = messageTextField.text,
//       user = UserInformation.currentUser else { return }
//        ThreadController.sharedController.addMessageToThread(messageText, thread: thread, displayName: user) { (success) in
//            if success == true {
//                print(messageText) 
//            }
//        }
    }
    
    @IBAction func nameTapped(sender: AnyObject) {
        presentAlertController()
        
        // TODO: if cancel, return else { return segue with identifier }, create segue if DM is selected.
        performSegueWithIdentifier("toPrivateChat", sender: self)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("messageCell", forIndexPath: indexPath)
        
        let message = messages[indexPath.row]
        cell.textLabel?.text = "    \(message.displayName ?? "")         \(message.timestamp.dateFormat())"
        cell.detailTextLabel?.text = message.message
        
        return cell
    }
    
    func presentAlertController() {
        let actionSheet = UIAlertController(title: "\(UserInformation.displayNameKey)", message: "What would you like to do?", preferredStyle: .ActionSheet)
    
        
        let directMessageAction = UIAlertAction(title: "Direct Message", style: .Default, handler: nil) // Add code in the handler to set button functionalility
        let reportAction = UIAlertAction(title: "Report", style: .Default, handler: nil) // Add code in the handler to set button functionalility
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        actionSheet.addAction(directMessageAction)
        actionSheet.addAction(reportAction)
        actionSheet.addAction(cancelAction)
        
        presentViewController(actionSheet, animated: true, completion: nil)
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
