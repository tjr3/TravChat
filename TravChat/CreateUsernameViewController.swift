//
//  createUsernameViewController.swift
//  TravChat
//
//  Created by Tyler on 7/9/16.
//  Copyright © 2016 Tyler. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

class createUsernameViewController: UIViewController {
    
    var displayName: String?
    var users = [NSManagedObject]()
    
    // MARK: - Outlets -
    
    @IBOutlet weak var travChatLabel: UILabel!
    
    @IBOutlet weak var signInLabel: UILabel!
    
    @IBOutlet weak var firstNameLabel: UILabel!
    
    @IBOutlet weak var lastNameLabel: UILabel!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        configureView()
    }
    
    
    func configureView() {
        guard signInLabel != nil else { return }
        _ = (UIFont(name: "PingFangHK-Medium", size: 20.0))
        _ = UIColor.blackColor()
        guard firstNameLabel != nil else {return }
        _ = (UIFont(name: "PingFangHK-UltraThin", size: 15.0))
        _ = UIColor.blackColor()
        guard lastNameLabel != nil else {return }
        _ = (UIFont(name: "PingFangHK-UltraThin", size: 15.0))
        _ = UIColor.blackColor()
    }
    
    
    func createUser() {
        let firstName = firstNameTextField.text
        let lastName = lastNameTextField.text
        
        let displayName = ("\(firstName)" + " " + "\(lastName)")
        
        self.displayName = displayName
        
        UserController.sharedController.createUser(displayName)
    }


    // MARK: - Action Button -
    
    @IBAction func createButtonTapped(sender: AnyObject) {
        
        if let displayName = displayName {
        _ = UserInformation(displayName: displayName)
        }
        
        createUser()
        
        UserController.sharedController.saveContext()
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
