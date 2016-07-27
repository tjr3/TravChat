//
//  PrivateChatTableViewCell.swift
//  TravChat
//
//  Created by Tyler on 7/20/16.
//  Copyright © 2016 Tyler. All rights reserved.
//

import UIKit

class PrivateChatTableViewCell: UITableViewCell {

    
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var rightArrowImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateWith(thread: Thread) {
        if let name = thread.name {
            displayNameLabel.text = name
        }
    }
}
