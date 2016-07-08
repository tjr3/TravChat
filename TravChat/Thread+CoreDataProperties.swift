//
//  Thread+CoreDataProperties.swift
//  TravChat
//
//  Created by Tyler on 7/6/16.
//  Copyright © 2016 Tyler. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Thread {

    @NSManaged var name: String?
    @NSManaged var oneToOne: NSNumber
    @NSManaged var messages: NSSet?
    @NSManaged var userInformations: NSSet?

}
