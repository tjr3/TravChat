//
//  DateFormatter.swift
//  TravChat
//
//  Created by Tyler on 7/11/16.
//  Copyright © 2016 Tyler. All rights reserved.
//

import Foundation

extension NSDate {
    func dateFormat() -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.dateStyle = .ShortStyle
        
        return dateFormatter.stringFromDate(self)
    }
}