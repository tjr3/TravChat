//
//  SecondaryDateFormatter.swift
//  TravChat
//
//  Created by Tyler on 7/19/16.
//  Copyright © 2016 Tyler. All rights reserved.
//

import Foundation
import Foundation

extension NSDate {
    func secondaryDateFormat() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        
        return dateFormatter.stringFromDate(self)
    }
}