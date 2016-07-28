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
        runAnimations { 
            self.regionSegueDelegate?.performRegionSegue(self)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func runAnimations(completion: () -> Void) {
        
        UIView.animateWithDuration(0.1, animations: {
            self.transform = CGAffineTransformMakeScale(0.92, 0.92)
            
            }, completion: { (finish) in
                UIView.animateWithDuration(0.2, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: [UIViewAnimationOptions.BeginFromCurrentState], animations: {
                    self.transform = CGAffineTransformMakeScale(1.0, 1.0)
                    
                    }, completion: { (finish) in
                        completion()
                })
        })
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
