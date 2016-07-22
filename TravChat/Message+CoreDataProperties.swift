//
//  Message+CoreDataProperties.swift
//  TravChat
//
//  Created by Tyler on 7/22/16.
//  Copyright © 2016 Tyler. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Message {

    @NSManaged var displayName: String?
    @NSManaged var message: String
    @NSManaged var thread: Thread?
    @NSManaged var user: UserInformation?

}
