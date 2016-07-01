//
//  Message.swift
//  TravChat
//
//  Created by Tyler on 6/30/16.
//  Copyright © 2016 Tyler. All rights reserved.
//

import Foundation
import CoreData


class Message: Thread {

    static let messageKey = "Message"
    static let timestampKey = "timestamp"
    
    convenience init(message: String, timestamp: NSDate = NSDate(), context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        
        guard let entity = NSEntityDescription.entityForName(Message.messageKey, inManagedObjectContext: context) else { fatalError("Error: Core Data failed to create entity from entity description.") }
        
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.message = message
        self.timestamp = timestamp
        self.recordName = self.nameForManagedObject()

}
}