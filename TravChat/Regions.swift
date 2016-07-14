//
//  Regions.swift
//  TravChat
//
//  Created by Tyler on 7/6/16.
//  Copyright © 2016 Tyler. All rights reserved.
//

import Foundation
import UIKit

enum Region: Int {
    
    case Africa
    case Asia
    case Australia
    case Europe
    case NorthAmerica
    case SouthAmerica
    
    var image: UIImage? {
        switch self {
            
        case .Africa:
            return UIImage(named: "Africa")
        case .Asia:
            return UIImage(named: "Asia")
        case .Australia:
            return UIImage(named: "Australia")
        case .Europe:
            return UIImage(named: "Europe")
        case .NorthAmerica:
            return UIImage(named: "NorthAmerica")
        case .SouthAmerica:
            return UIImage(named: "SouthAmerica")
        }
    }
    
    var name: String {
        switch self {
            
        case .Africa:
            return "Africa"
        case .Asia:
            return "Asia"
        case .Australia:
            return "Australia"
        case .Europe:
            return "Europe"
        case .NorthAmerica:
            return "North America"
        case .SouthAmerica:
            return "South America"
        }
    }
}


