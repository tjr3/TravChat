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
    
    var cloudKitManager: CloudKitManager
    var isSyncing: Bool = false
    
    // MARK: - Thread Creation -
    
    var africa: Thread!
    var asia: Thread!
    var australia: Thread!
    var europe: Thread!
    var northAmerica: Thread!
    var southAmerica: Thread!
    
    var regionsArray = ["Africa", "Asia", "Australia", "Europe", "North America", "South America"]
    
    var threads: [Thread] {
        let fetchRequest = NSFetchRequest(entityName: "Thread")
        let predicate = NSPredicate(format: "oneToOne == 0")
        fetchRequest.predicate = predicate
        
        return try! Stack.sharedStack.managedObjectContext.executeFetchRequest(fetchRequest) as? [Thread] ?? []
    }
    
    var oneToOneThreads: [Thread]? {
        let request = NSFetchRequest(entityName: "Thread")
        let predicate = NSPredicate(format: "oneToOne == 1")
        request.predicate = predicate
        
        return try! Stack.sharedStack.managedObjectContext.executeFetchRequest(request) as? [Thread] ?? nil
        
    }
    
    var messages: [Message] {
        let fetchRequest = NSFetchRequest(entityName: Message.typeKey)
        let sortDescriptor = NSSortDescriptor(key: Message.timestampKey, ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let results = (try? Stack.sharedStack.managedObjectContext.executeFetchRequest(fetchRequest)) as? [Message] ?? []
        return results
    }
    
    init () {
        self.cloudKitManager = CloudKitManager()
        performFullSync()
        createRegions()
        createOneToOne()
    }
    
    //MARK: - Threads -
    
    func createRegions() {
        if self.threads.count == 0 {
            self.africa = Thread(name: "Africa")
            self.asia = Thread(name: "Asia")
            self.australia = Thread(name: "Australia")
            self.europe = Thread(name: "Europe")
            self.northAmerica = Thread(name: "North America")
            self.southAmerica = Thread(name: "South America")
            
            guard let currentUser = UserController.sharedController.currentUser else {
                return
            }
            
            // TODO: MockData - Delete when no longer needed.
            addMessageToThread("Sendia is Amazing", user: currentUser, thread: self.asia, displayName: "TLARbot", completion: nil)
            addMessageToThread("Ghana", user: currentUser, thread: self.africa, displayName: "RmackayAllDay", completion: nil)
            addMessageToThread("Brisbane", user: currentUser, thread: self.australia, displayName: "ShelbyFlen", completion: nil)
            addMessageToThread("Genoa", user: currentUser, thread: self.europe, displayName: "JWebb", completion: nil)
            addMessageToThread("Lake Powell!! ", user: currentUser, thread: self.northAmerica, displayName: "J_CENTS", completion: nil)
            addMessageToThread("Bolivia", user: currentUser, thread: self.southAmerica, displayName: "Prodg", completion: nil)
            saveContext()
        }
    }
    
    func createOneToOne() {
        let JCents = Thread.init(name: "JCents", oneToOne: true)
        let steve  = Thread.init(name: "SteveO", oneToOne: true)
        let bob = Thread.init(name: "Bob", oneToOne: true)
        let kojack = Thread.init(name: "Kojack", oneToOne: true)
        
        guard let currentUser = UserController.sharedController.currentUser else {
            return
        }
        
        addMessageToThread("If you go to Amsterdam, dont go to the red light district", user: currentUser, thread: JCents, displayName: "JCents", completion: nil)
        addMessageToThread("Go to Cafe Du Monde in NOLA", user: currentUser, thread: bob, displayName: "Bob", completion: nil)
        addMessageToThread("Get the beignets!", user: currentUser, thread: bob, displayName: "Bob", completion: nil)
        addMessageToThread("The Raiders Cafe in Oakland is dank!", user: currentUser, thread: steve, displayName: "SteveO", completion: nil)
        addMessageToThread("Big ben is overrated, go to the Camden Markets", user: currentUser, thread: kojack, displayName: "Kojack", completion: nil)
    }
    
    // MARK: - Method Signatures -
    
    func createOneToOneChat(users: [UserInformation]) -> Thread? {
        if let currentUser = UserController.sharedController.currentUser{
            var threadName = "\(currentUser.displayName)"
            for user in users {
                if let displayName = user.displayName {
                    threadName += ", \(displayName)"
                }
            }
            
            let oneToOneThread = Thread(message: NSSet(), name: threadName, oneToOne: true, userInformation: NSSet(array: users))
            saveContext()
            
            if let oneToOneThreadRecord = oneToOneThread.cloudKitRecord {
                
                cloudKitManager.saveRecord(oneToOneThreadRecord, completion: { (record, error) in
                    if let record = record {
                        oneToOneThread.update(record)
                    }
                })
            }
            return oneToOneThread
        } else {
            return nil
        }
    }
    
    func threadWithName(name: String) -> Thread? {
        
        if name.isEmpty { return nil }
        
        let fetchRequest = NSFetchRequest(entityName: "Thread")
        let predicate = NSPredicate(format: "recordName == %@", argumentArray: [name])
        fetchRequest.predicate = predicate
        
        let result = (try? Stack.sharedStack.managedObjectContext.executeFetchRequest(fetchRequest) as? [Thread]) ?? nil
        
        return result?.first
    }
    
    func deleteThread(thread: Thread) {
        
        if let recordID = thread.cloudKitRecordID {
            cloudKitManager.deleteRecordWithID(recordID, completion: { (recordID, error) in
                
                if let error = error {
                    print("\(error.localizedDescription)")
                }
            })
        }
        thread.managedObjectContext?.deleteObject(thread)
        saveContext()
    }
    
    func addMessageToThread(message: String, user: UserInformation, thread: Thread, displayName: String, completion: ((message: Message) -> Void)?) { // takes in message and thread, refer Timeline
        
        let message = Message(thread: thread, message: message, displayName: displayName, user: user)
        saveContext()
        
        if let completion = completion {
            completion(message: message)
        }
        
        if let messageRecord = message.cloudKitRecord {
            
            cloudKitManager.saveRecord(messageRecord, completion: { (record, error) in
                if let record = record {
                    message.update(record)
                }
            })
        }
    }
    
    func removeMessageFromThread(thread: Thread, message: Message, displayName: String, completion: ((success: Bool) -> Void)?) { // takes in message and thread, refer Timeline
        
        thread.managedObjectContext?.deleteObject(message)
        saveContext()
    }
    
    // MARK: - Syncable Records -
    
    func syncedRecords(type: String) -> [CloudKitManagedObject] { // this just shows you which records are synced between cloudkit and core data
        let fetchRequest = NSFetchRequest(entityName: type)
        let predicate = NSPredicate(format: "recordID != nil")
        
        fetchRequest.predicate = predicate
        
        let results = (try? Stack.sharedStack.managedObjectContext.executeFetchRequest(fetchRequest)) as? [CloudKitManagedObject] ?? []
        
        return results
    }
    
    func unsyncedRecords(type: String) -> [CloudKitManagedObject] { // this just shows you which records are unsynced between cloudkit and core data
        let fetchRequest = NSFetchRequest(entityName: type)
        let predicate = NSPredicate(format: "recordID == nil")
        
        fetchRequest.predicate = predicate
        
        let results = (try? Stack.sharedStack.managedObjectContext.executeFetchRequest(fetchRequest)) as? [CloudKitManagedObject] ?? []
        
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
    
    // MARK: - Fetch Records -
    
    func fetchNewRecords(type: String, completion: (() -> Void)?) {
        
        let referencesToExclude = syncedRecords(type).flatMap({ $0.cloudKitReference})
        //        var prediate = NSPredicate(format: "NOT(recordID IN %@", argumentArray: [referencesToExclude])
        
        if referencesToExclude.isEmpty {
            //            prediate = NSPredicate(value: true)
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
    
    // MARK: - Save Content -
    
    func saveContext() {
        
        do {
            try Stack.sharedStack.managedObjectContext.save()
        } catch {
            print("Unable to save context. \(error)")
        }
    }
}

