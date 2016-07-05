//
//  UserInformation+CoreDataProperties.swift
//  TravChat
//
//  Created by Tyler on 7/5/16.
//  Copyright © 2016 Tyler. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension UserInformation {

    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var thread: NSSet?

}
