//
//  Thread Controller.swift
//  TravChat
//
//  Created by Tyler on 6/29/16.
//  Copyright © 2016 Tyler. All rights reserved.
//

import UIKit
import CoreData

class ThreadController {
    
    static let sharedController = ThreadController()
    
    var cloudKitManager = CloudKitManager()
    
    var isSyncing: Bool = false
    
    var messages: [Message] {
        let fetchRequest = NSFetchRequest(entityName: Message.typeKey)
        let sortDescriptor = NSSortDescriptor(key: Message.timestampKey, ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let results = (try? Stack.sharedStack.managedObjectContext.executeRequest(fetchRequest)) as? [Message] ?? []
        
        return results
    }
    
    init () {
        
        self.cloudKitManager = CloudKitManager()
        
        performFullSync()
        
        
    }
    
    //MARK: - Thread -
    
    func createThread() {
        
    }
    
    func deleteThread() {
        
    }
    
    func addMessageToThread() {
        
    }
    
    func removeMessageFromThread() {
        
    }
    
    // MARK: Syncable Records -
    
    func syncedRecords(type: String) -> [CloudKitManagedObject] { // this just shows you which records are synced between cloudkit and core data
        let fetchRequest = NSFetchRequest(entityName: type)
        let predicate = NSPredicate(format: "recordID != nil")
        
        fetchRequest.predicate = predicate
        
        let results = (try? Stack.sharedStack.managedObjectContext.executeRequest(fetchRequest)) as? [CloudKitManagedObject] ?? []
        
        return results
    }
    
    func unsyncedRecords(type: String) -> [CloudKitManagedObject] { // this just shows you which records are unsynced between cloudkit and core data
        let fetchRequest = NSFetchRequest(entityName: type)
        let predicate = NSPredicate(format: "recordID == nil")
        
        fetchRequest.predicate = predicate
        
        let results = (try? Stack.sharedStack.managedObjectContext.executeRequest(fetchRequest)) as? [CloudKitManagedObject] ?? []
        
        return results
    }
    
    func performFullSync(completion: (() -> Void)? = nil) { // this syncs the records between coredata and cloudkit
        
        if isSyncing {
            if let completion = completion {
                completion()
            }
        } else {
            isSyncing = true
            
            pushChangesToCloudKit { (success, error) in
                
                self.fetchNewRecords(Message.typeKey) {
                    
                    self.fetchNewRecords(Thread.typeKey, completion: {
                        
                        self.isSyncing = false
                        
                        if let completion = completion {
                            
                            completion()
                        }
                    })
                }
            }
        }
    }
    
    // MARK: Fetch Records -
    
    func fetchNewRecords(type: String, completion: (() -> Void)?) {
        
        let referencesToExclude = syncedRecords(type).flatMap({ $0.cloudKitReference})
        var prediate = NSPredicate(format: "NOT(recordID IN %@", argumentArray: [referencesToExclude])
        
        if referencesToExclude.isEmpty {
            prediate = NSPredicate(value: true)
        }
        
        cloudKitManager.fetchRecordsWithType(type, predicate: prediate, recordFetchedBlock: { (record) in
            
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
    
    // MARK: Save Content -
    
    func saveContext() {
        
        do {
            try Stack.sharedStack.managedObjectContext.save()
        } catch {
            print("Unable to save context. \(error)")
        }
    }
}

