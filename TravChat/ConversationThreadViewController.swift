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
//    var user = UserInformation?
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var conversationTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let region = conversationRegion else { return }
        self.title = region.name
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Action Buttons -
    
    @IBAction func sendButtonTapped(sender: AnyObject) {
//        guard let messageText = messageTextField.text,
//        thread = self.thread,
//        user = else { return }
//        ThreadController.sharedController.addMessageToThread(messageText, thread: <#T##Thread#>, user: <#T##String#>, completion: <#T##((success: Bool) -> Void)?##((success: Bool) -> Void)?##(success: Bool) -> Void#>)
//    }
    }
    
    @IBAction func nameTapped(sender: AnyObject) {
        presentAlertController()
        // if cancel, return else { return segue with identifier }
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
        cell.textLabel?.text = "\(message.displayName) \(message.timestamp.dateFormat())"
        cell.detailTextLabel?.text = message.message
        
        return cell
    }
    
    func presentAlertController() {
        
        let alertController = UIAlertController(title: "Private Chat?", message: "Do you want start a new privetate chat with \(UserInformation.firstNameKey) \(UserInformation.lastNameKey)?", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let createAction = UIAlertAction(title: "Yes", style: .Default, handler: nil)
        
        alertController.addAction(cancelAction)
        alertController.addAction(createAction)
        presentViewController(alertController, animated: true, completion: nil)
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
