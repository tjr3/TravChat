//
//  AppDelegate.swift
//  TravChat
//
//  Created by Tyler on 6/29/16.
//  Copyright © 2016 Tyler. All rights reserved.
//

import UIKit
import CloudKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        if UserController.sharedController.currentUser == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("signin")
            self.window?.rootViewController = vc
        }
        
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        return true
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        guard let notificationInfo = userInfo as? [String: NSObject] else { return }
        
        let queryNotification = CKQueryNotification(fromRemoteNotificationDictionary: notificationInfo)
        
        guard let recordID = queryNotification.recordID else { print("No Record ID available from CKQueryNotification."); return }
        
        let cloudKitManager = ThreadController.sharedController.cloudKitManager
        
        cloudKitManager.fetchRecordWithID(recordID) { (record, error) in
            
            guard let record = record else { print("Unable to fetch CKRecord from Record ID"); return }
            switch record.recordType {
            case Thread.typeKey:
                let _ = Thread(record: record)
            case Message.typeKey:
                let _ = Message(record: record)
            default:
                return
            }
            
            ThreadController.sharedController.saveContext()
        }
        completionHandler(UIBackgroundFetchResult.NewData)
    }
    
    // Reference Timeline for App Delegate Method
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}