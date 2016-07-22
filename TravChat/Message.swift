//
//  Message.swift
//  TravChat
//
//  Created by Tyler on 7/5/16.
//  Copyright © 2016 Tyler. All rights reserved.
//

import Foundation
import CoreData
import CloudKit

class Message: SyncableObject, CloudKitManagedObject {
    
    static let typeKey = "Message"
    static let displayNameKey = "displayName"
    static let threadKey = "thread"
    static let timestampKey = "timestamp"
    static let messageKey = "message"
    static let userKey = "user"
    
    convenience init(thread: Thread, message: String, displayName: String, user: UserInformation?, timestamp: NSDate = NSDate(), context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        
        guard let entity = NSEntityDescription.entityForName(Message.typeKey, inManagedObjectContext: context) else { fatalError("Error: Core Data failed to create entity from entity description.") }
        
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.message = message
        self.thread = thread
        self.displayName = displayName
        self.timestamp = timestamp
        self.recordName = self.nameForManagedObject()
        self.thread = thread
        self.user = user
    }
    
    // MARK: CloudKitManagedObject
    
    var recordType: String = Message.typeKey
    
    var cloudKitRecord: CKRecord? {
        
        let recordID = CKRecordID(recordName: recordName)
        let record = CKRecord(recordType: recordType, recordID: recordID)
        
        record[Message.timestampKey] = timestamp
        record[Message.displayNameKey] = displayName
        record[Message.messageKey] = message
        
//        record[Message.userKey] = user   see thread = thread below
        
        
        guard let thread = thread,
            let threadRecord = thread.cloudKitRecord else { fatalError("Message does not have a thread relationship") }
        
        record[Message.threadKey] = CKReference(record: threadRecord, action: .DeleteSelf)
        
        return record
    }
    
    
    convenience required init?(record: CKRecord, context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        
        guard let timestamp = record.creationDate,
            let message = record[Message.messageKey] as? String,
            let displayName = record[Message.displayNameKey] as? String,
            let threadReference = record[Message.threadKey] as? CKReference else { return nil }
        
        guard let entity = NSEntityDescription.entityForName(Message.typeKey, inManagedObjectContext: context) else { fatalError("Error: Core Data failed to create entity from entity description.") }
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.timestamp = timestamp
        self.message = message
        self.displayName = displayName
        self.recordID = NSKeyedArchiver.archivedDataWithRootObject(record.recordID)
        self.recordName = record.recordID.recordName
        
        if let thread = ThreadController.sharedController.threadWithName(threadReference.recordID.recordName) {
            self.thread = thread
        }
    }
}
