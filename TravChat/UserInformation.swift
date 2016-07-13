//
//  UserInformation.swift
//  TravChat
//
//  Created by Tyler on 7/5/16.
//  Copyright © 2016 Tyler. All rights reserved.
//

import Foundation
import CoreData
import CloudKit

class UserInformation: SyncableObject, CloudKitManagedObject{

    static let typeKey = "UserInformation"
    static let displayNameKey = "displayName"
    
    static var currentUserDisplayName = UserInformation.displayNameKey
    
    convenience init(displayName: String, timestamp: NSDate = NSDate(), context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        
        guard let entity = NSEntityDescription.entityForName(UserInformation.typeKey, inManagedObjectContext: context) else { fatalError("Error: Core Data failed to create entity from entity description.") }
        
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.displayName = displayName
        self.timestamp = timestamp
        self.recordName = self.nameForManagedObject()
    }
    
  
    
    // MARK: CloudKitManagedObject
    
    var recordType: String = UserInformation.typeKey
    
    var cloudKitRecord: CKRecord? {
        
        let recordID = CKRecordID(recordName: recordName)
        let record = CKRecord(recordType: recordType, recordID: recordID)
        
        record[UserInformation.displayNameKey] = displayName
        
        return record
    }
    
    convenience required init?(record: CKRecord, context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        
        guard let entity = NSEntityDescription.entityForName(UserInformation.typeKey, inManagedObjectContext: context) else { fatalError("Core Data failed to create entity from entity description.") }
        
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.recordName = record.recordID.recordName
        self.recordID = NSKeyedArchiver.archivedDataWithRootObject(record.recordID)
    }
}

