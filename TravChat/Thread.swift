//
//  Thread.swift
//  TravChat
//
//  Created by Tyler on 7/5/16.
//  Copyright © 2016 Tyler. All rights reserved.
//

import Foundation
import CoreData
import CloudKit


class Thread: SyncableObject {

    static let typeKey = "Thread"
    static let nameKey = "name"
    static let messageKey = "messages"
    static let timestampKey = "timestamp"
    
    convenience init(thread: Thread, message: NSSet = NSSet(), name: String, userInformation: NSSet = NSSet(), context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        
        guard let entity = NSEntityDescription.entityForName(Thread.typeKey, inManagedObjectContext: context) else { fatalError("Error: Core Data failed to create an entity from entity description.") }
        
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.messages = message
        self.name = name
        self.userInformations = userInformation
        self.recordName = recordName
        
    }
    
    // MARK: CloudKitManagedObject
    
    var recordType: String = Thread.typeKey
    
    var cloudKitRecord: CKRecord? {
        
        let recordID = CKRecordID(recordName: recordName)
        let record = CKRecord(recordType: recordType, recordID: recordID)
        
        record[Thread.timestampKey] = timestamp
        record[Thread.nameKey] = name

        
        return record
    }
    
    convenience required init?(record: CKRecord, context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        
        guard let entity = NSEntityDescription.entityForName(Thread.typeKey, inManagedObjectContext: context) else { fatalError("Error: Core Data failed to create an enitiy from entity description.") }
        
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.recordName = record.recordID.recordName
        self.recordID = NSKeyedArchiver.archivedDataWithRootObject(record.recordID)
    
    }
}

