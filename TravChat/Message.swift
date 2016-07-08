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
    
    convenience init(thread: Thread, message: String, displayName: String, timestamp: NSDate = NSDate(), context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        
        guard let entity = NSEntityDescription.entityForName(Message.typeKey, inManagedObjectContext: context) else { fatalError("Error: Core Data failed to create entity from entity description.") }
        
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.message = message
        self.thread = thread
        self.displayName = displayName
        self.timestamp = timestamp
        self.recordName = recordName
        self.thread = thread
    }
    
    // MARK: CloudKitManagedObject
    
    var recordType: String = Message.typeKey
    
    var cloudKitRecord: CKRecord? {
        
        let recordID = CKRecordID(recordName: recordName)
        let record = CKRecord(recordType: recordType, recordID: recordID)
        
        record[Message.timestampKey] = timestamp
        record[Message.displayNameKey] = displayName

        
        guard let thread = thread,
            let threadRecord = thread.cloudKitRecord else { fatalError("Message does not have a thread relationship") }
        record[Message.threadKey] = thread.name
        
        record[Message.typeKey] = CKReference(record: threadRecord, action: .DeleteSelf)
        
            return record
        }

    
    convenience required init?(record: CKRecord, context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        
        guard let timestamp = record.creationDate else { return nil }
        
        guard let entity = NSEntityDescription.entityForName(Message.typeKey, inManagedObjectContext: context) else { fatalError("Error: Core Data failed to create entity from entity description.") }
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.timestamp = timestamp
        self.recordID = NSKeyedArchiver.archivedDataWithRootObject(record.recordID)
        self.recordName = record.recordID.recordName
    }
}
