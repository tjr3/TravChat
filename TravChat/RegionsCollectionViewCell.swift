//
//  RegionsCollectionViewCell.swift
//  TravChat
//
//  Created by Tyler on 7/6/16.
//  Copyright © 2016 Tyler. All rights reserved.
//

import UIKit

protocol PerformRegionSegueDelegate: class {
    func performRegionSegue(sender: RegionsCollectionViewCell)
}

class RegionsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var regionButton: UIButton!
    
    var name: String = ""
    
    weak var regionSegueDelegate: PerformRegionSegueDelegate?
    
    @IBAction func regionButtonTapped() {
        regionSegueDelegate?.performRegionSegue(self)
    }
    
    func updateWithButtonImage(image: UIImage, name: String, fontSize: CGFloat) {
        self.name = name
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.Center
        let attributedString = NSAttributedString(string: name, attributes: [NSFontAttributeName: UIFont(name: "CourierNewPSMT", size: fontSize)!, NSForegroundColorAttributeName: UIColor.blackColor(), NSParagraphStyleAttributeName: style ])
        regionButton.setAttributedTitle(attributedString, forState: .Normal)
        regionButton.setBackgroundImage(image, forState: .Normal)
        
        regionButton.setAttributedTitle(attributedString, forState: .Normal)
    }
}
