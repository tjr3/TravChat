//
//  CloudKitManagedObject.swift
//  TravChat
//
//  Created by Tyler on 7/5/16.
//  Copyright © 2016 Tyler. All rights reserved.
//

import Foundation
import CloudKit
import CoreData

@objc protocol CloudKitManagedObject {
    
    var timestamp: NSDate { get set }
    var recordID: NSData? { get set }
    var recordName: String { get set }
    var recordType: String { get }
    var cloudKitRecord: CKRecord? { get }
    
    init?(record: CKRecord, context: NSManagedObjectContext)
}

extension CloudKitManagedObject {
    
    var isSynced: Bool {
        
        return recordID != nil
    }
    
    var cloudKitRecordID: CKRecordID? {
       
        guard let recordID = recordID,
            let recordIDData = NSKeyedUnarchiver.unarchiveObjectWithData(recordID) as? CKRecordID else { return nil }
        
        return recordIDData
    }
    
    var cloudKitReference: CKReference? {
        
        guard let recordID = cloudKitRecordID else { return nil }
        
        return CKReference(recordID: recordID, action: .None)
    }
    
    func update(record: CKRecord) {
        
        self.recordID = NSKeyedArchiver.archivedDataWithRootObject(record.recordID)
        
        do {
            try Stack.sharedStack.managedObjectContext.save()
        } catch {
            print("Unable to save Managed Object Context: \(error)")
        }
    }
    
    func nameForManagedObject() -> String {
        
        return NSUUID().UUIDString
    }
}