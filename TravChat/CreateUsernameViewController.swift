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
    var activeTextField: UITextField!
    
    // MARK: - Outlets -
    
    @IBOutlet weak var travChatLabel: UILabel!
    
    @IBOutlet weak var signInLabel: UILabel!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var beginChattingButton: UIButton!
    
    
    // MARK: - Method Signatures -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        buttonShadow()
    }

    func configureView() {
        guard signInLabel != nil else { return }
        _ = (UIFont(name: "PingFangHK-Medium", size: 20.0))
        _ = UIColor.blackColor()
    }
    
    func buttonShadow() {
        travChatLabel.layer.shadowColor = UIColor.blackColor().CGColor
        travChatLabel.layer.shadowOffset = CGSizeMake(5, 5)
        travChatLabel.layer.shadowRadius = 5
        travChatLabel.layer.shadowOpacity = 0.50
    }
    
    
    func createUser() {
        if let displayName = firstNameTextField.text {
            
            let displayName = ("\(displayName)")
            
            self.displayName = displayName
            
            UserController.sharedController.createUser(displayName)
        } else {
            // TODO: Error handleing
            print("Unable to create user name")
        }
    }
    
    
    // MARK: - Action Button -
    
    @IBAction func createButtonTapped(sender: AnyObject) {
        
        if let displayName = displayName {
            _ = UserInformation(displayName: displayName)
        }
        
        createUser()
        
        UserController.sharedController.saveContext()
    }
    @IBAction func dismissKeyboardOnTouch(sender: AnyObject) {
        firstNameTextField.resignFirstResponder()
    }
}
