//
//  Thread.swift
//  TravChat
//
//  Created by Tyler on 6/30/16.
//  Copyright © 2016 Tyler. All rights reserved.
//

import Foundation
import CoreData


class Thread: NSManagedObject {
    
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
        
    }
    
    // MARK: CloudKitManagedObject
    
    var recordType: String = Thread.typeKey
    
    
    
    
}

