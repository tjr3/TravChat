//
//  Thread.swift
//  TravChat
//
//  Created by Tyler on 7/6/16.
//  Copyright © 2016 Tyler. All rights reserved.
//

import Foundation
import CoreData
import CloudKit


class Thread: SyncableObject, CloudKitManagedObject {
    
    static let typeKey = "Thread"
    static let nameKey = "name"
    static let oneToOneKey = "oneToOne"
    static let messageKey = "messages"
    static let timestampKey = "timestamp"
    
    convenience init(message: NSSet = NSSet(), name: String, oneToOne: Bool = false, userInformation: NSSet = NSSet(), context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        
        guard let entity = NSEntityDescription.entityForName(Thread.typeKey, inManagedObjectContext: context) else { fatalError("Error: Core Data failed to create an entity from entity description.") }
        
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.messages = message
        self.name = name ?? ""
        self.userInformations = userInformation
        self.oneToOne = oneToOne
        self.recordName = self.nameForManagedObject()
        self.timestamp = NSDate()
        
    }
    
    // MARK: CloudKitManagedObject
    
    var recordType: String = Thread.typeKey
    
    var cloudKitRecord: CKRecord? {
        
        let recordID = CKRecordID(recordName: recordName)
        let record = CKRecord(recordType: recordType, recordID: recordID)
        
        record[Thread.timestampKey] = timestamp
        record[Thread.nameKey] = name
        record[Thread.oneToOneKey] = oneToOne
        
        return record
    }
    
    convenience required init?(record: CKRecord, context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        
        guard let entity = NSEntityDescription.entityForName(Thread.typeKey, inManagedObjectContext: context) else { fatalError("Error: Core Data failed to create an enitiy from entity description.") }
        
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        guard let timestamp = record.creationDate,
            let name = record[Thread.nameKey] as? String,
            let oneToOne = record[Thread.oneToOneKey] as? NSNumber else { fatalError() }
        
        self.timestamp = timestamp
        self.name = name
        self.oneToOne = oneToOne
        self.recordName = record.recordID.recordName
        self.recordIDData = NSKeyedArchiver.archivedDataWithRootObject(record.recordID)
        
    }
}
