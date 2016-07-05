//
//  UserInformation.swift
//  TravChat
//
//  Created by Tyler on 7/1/16.
//  Copyright © 2016 Tyler. All rights reserved.
//

import Foundation
import CoreData


class UserInformation: NSManagedObject {
    
    static let typeKey = "UserInformation"
    static let nameKey = "firstName"
    
    convenience init(userInformation: UserInformation, firstName: String, lastName: String, context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        
        guard let entity = NSEntityDescription.entityForName(UserInformation.typeKey, inManagedObjectContext: context) else { fatalError("Error: Core Data failed to create entity from entity description.") }
        
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.firstName = firstName
        self.lastName = lastName
    }
    
    // MARK: CloudKitManagedObject
    
    
}



