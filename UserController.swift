//
//  UserController.swift
//  TravChat
//
//  Created by Tyler on 7/9/16.
//  Copyright © 2016 Tyler. All rights reserved.
//

import UIKit
import CoreData
import CloudKit

class UserController {
    
    private var kDisplayName = "displayName"
    
    static let sharedController = UserController()
    
    let cloudKitManager: CloudKitManager
    var isSyncing: Bool = false
    
    init() {
        self.cloudKitManager = CloudKitManager()
    }
    
    var userInformation: UserInformation?
    
    var currentUser: [UserInformation]? {
        let request = NSFetchRequest(entityName: "UserInformation")
        return try? Stack.sharedStack.managedObjectContext.executeFetchRequest(request) as? [UserInformation] ?? []
//        do {
//        } catch {
//            return nil
//        }
        
    }
    
//    var saveCurrentUser: UserInformation? {
//        get {
//            let userDisplayName = NSFetchRequest(entityName: "UserInformation")
//            let userDictionary = NSUserDefaults.standardUserDefaults().valueForKey(kDisplayName) as? [String : AnyObject]
//            return UserInformation(displayName: userDictionary, context: Stack.sharedStack.managedObjectContext)
//
//            return UserInformation?
//        }
//        set {
//            
//        }
//    }
    
    // MARK: - Method Signatures -
    
    func createUser(displayName: String) {
        
        let newUser = UserInformation(displayName: displayName, context: Stack.sharedStack.managedObjectContext)
        saveContext()
        
        if let displayNameRecord = newUser.cloudKitRecord {
            
            
            cloudKitManager.saveRecord(displayNameRecord, completion: { (record, error) in
                if let record = record {
                    newUser.update(record)
                    
                    print(displayNameRecord)
                }
            })
        }
    }
    
    func deleteUser(user: UserInformation) {
        if let recordID = user.cloudKitRecordID {
            cloudKitManager.deleteRecordWithID(recordID, completion: { (recordID, error) in
                
                if let error = error {
                    print("\(error.localizedDescription)")
                }
            })
        }
        
        user.managedObjectContext?.deleteObject(user)
        saveContext()
    }
    
    func removeUserFromThread(thread: Thread, user: UserInformation, completion: ((success: Bool) -> Void)?) {
        
        thread.managedObjectContext?.deleteObject(user)
        saveContext()
    }
    
    // MARK: Syncable Records -
    
    func syncedRecords(type: String) -> [CloudKitManagedObject] {
        let fetchRequest = NSFetchRequest(entityName: type)
        let predicate = NSPredicate(format: "recordID != nil")
        
        fetchRequest.predicate = predicate
        
        let results = (try? Stack.sharedStack.managedObjectContext.executeFetchRequest(fetchRequest)) as? [CloudKitManagedObject] ?? []
        return results
    }
    
    func unsyncedRecords(type: String) -> [CloudKitManagedObject] {
        let fetchRequest = NSFetchRequest(entityName: type)
        let predicate = NSPredicate(format: "recordID = nil")
        
        fetchRequest.predicate = predicate
        
        let results = (try? Stack.sharedStack.managedObjectContext.executeFetchRequest(fetchRequest)) as? [CloudKitManagedObject] ?? []
        return results
    }
    
    
    func performFullSync(completion: (() -> Void)? = nil) {
        
        if isSyncing {
            if let completion = completion {
                completion()
            }
        } else {
            
            isSyncing = true
            
            pushChangesToCloudKit { (success, error) in
                
                self.fetchNewRecords(UserInformation.typeKey, completion: {
                    self.isSyncing = false
                    
                    if let completion = completion {
                        completion()
                    }
                })
            }
        }
    }
    
    func fetchNewRecords(type: String, completion: (() -> Void)?) {
        
        let referencesToExclude = syncedRecords(type).flatMap({ $0.cloudKitReference})
        //        var prediate = NSPredicate(format: "NOT(recordID IN %@", argumentArray: [referencesToExclude])
        
        if referencesToExclude.isEmpty {
            //        prediate = NSPredicate(value: true)
        }
        
        cloudKitManager.fetchRecordsWithType(type, recordFetchedBlock: { (record) in
            
            switch type {
                
            case Thread.typeKey:
                let _ = Thread(record: record)
                
            case Message.typeKey:
                let _ = Message(record: record)
                
            default:
                return
            }
            
            self.saveContext()
            
        }) { (records, error) in
            
            if error != nil {
                print("Unable to fetch new records")
            }
            
            if let completion = completion {
                completion()
            }
        }
    }
    
    
    func pushChangesToCloudKit(completion: ((success: Bool, error: NSError?) -> Void)?) {
        
        let unsavedManagedObjects = unsyncedRecords(Message.typeKey) + unsyncedRecords(Thread.typeKey)
        let unsavedRecords = unsavedManagedObjects.flatMap({ $0.cloudKitRecord })
        
        cloudKitManager.saveRecords(unsavedRecords, perRecordCompletion: { (record, error) in
            
            guard let record = record else { return }
            
            if let matchingRecord = unsavedManagedObjects.filter({ $0.recordName == record.recordID.recordName }).first {
                
                matchingRecord.update(record)
            }
            
        }) { (records, error) in
            
            if let completion = completion {
                
                let success = records != nil
                completion(success: success, error: error)
            }
        }
    }
    
    
    // MARK: - Save Context -
    
    func saveContext() {
        do {
            try Stack.sharedStack.managedObjectContext.save()
        } catch {
            print("Unable to save context. \(error)")
        }
    }
}
