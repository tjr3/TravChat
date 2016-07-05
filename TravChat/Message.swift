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

class Message: SyncableObject {
    
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
    }
    
    // MARK: CloudKitManagedObject
    
    var recordType: String = Message.typeKey
    
    var cloudKitRecord: CKRecord? {
        
        let recordID = CKRecordID(recordName: recordName)
        let record = CKRecord(recordType: recordType, recordID: recordID)
        
        record[Message.timestampKey] = timestamp
        record[Message.displayNameKey] = displayName
        record[Message.threadKey] = self.thread.name
        
        return record
    }
    
    convenience init?(record: CKRecord, context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        
        guard let timestamp = record.creationDate,
            let  message = record[Message.typeKey] as? CKAsset else { return nil }
        
        guard let entity = NSEntityDescription.entityForName(Message.typeKey, inManagedObjectContext: context) else { fatalError("Error: Core Data failed to create entity from entity description.") }
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.timestamp = timestamp
        self.recordID = NSKeyedArchiver.archivedDataWithRootObject(record.recordID)
        self.message = String(message)
        self.recordName = record.recordID.recordName
    }
}