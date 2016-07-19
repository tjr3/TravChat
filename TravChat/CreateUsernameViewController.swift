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
    
    @IBOutlet weak var firstNameLabel: UILabel!
    
    @IBOutlet weak var lastNameLabel: UILabel!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var beginChattingButton: UIButton!
    
    
    // MARK: - Method Signatures -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        buttonShadow()
//        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(createUsernameViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: self.view.window)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(createUsernameViewController.keyboardWillHide(_:)), name: UIKeyboardWillShowNotification, object: self.view.window)
    }
    
//    override func viewWillDisappear(animated: Bool) {
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
//    }
    
    
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
    
    
    func buttonShadow() {
        travChatLabel.layer.shadowColor = UIColor.blackColor().CGColor
        travChatLabel.layer.shadowOffset = CGSizeMake(5, 5)
        travChatLabel.layer.shadowRadius = 5
        travChatLabel.layer.shadowOpacity = 0.50
    }
    
    
    func createUser() {
        if let firstName = firstNameTextField.text, lastName = lastNameTextField.text {
            
            let displayName = ("\(firstName)" + "\(lastName)")
            
            self.displayName = displayName
            
            UserController.sharedController.createUser(displayName)
        } else {
            // TODO: Error handleing
            print("Unable to create user name")
        }
    }
    
    // MARK: - Keyboard -
    
//    func keyboardWillShow(sender: NSNotification) {
//        let userInfo: [NSObject : AnyObject] = sender.userInfo!
//        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
//        let offset: CGSize = userInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue.size
//        
//        if keyboardSize.height == offset.height {
//            UIView.animateWithDuration(0.1, animations: { () -> Void in
//                self.view.frame.origin.y -= keyboardSize.height
//            })
//        } else {
//            UIView.animateWithDuration(0.1, animations: { () -> Void in
//                self.view.frame.origin.y += keyboardSize.height - offset.height
//            })
//        }
//    }
//    
//    func keyboardWillHide(sender: NSNotification) {
//        let userInfo: [NSObject : AnyObject] = sender.userInfo!
//        let keyboardSize: CGSize = userInfo[UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
//        self.view.frame.origin.y += keyboardSize.height
//    }
//    
//    
//    func textFieldDidBeginEditing(textField: UITextField) {
//        self.activeTextField = textField
//    }
//    
//    func textFieldDidEndEditing(text: UITextField) {
//        self.activeTextField = nil
//    }
//    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
    
    
    // MARK: - Action Button -
    
    @IBAction func createButtonTapped(sender: AnyObject) {
        
        if let displayName = displayName {
            _ = UserInformation(displayName: displayName)
        }
        
        createUser()
        
        UserController.sharedController.saveContext()
    }
}
