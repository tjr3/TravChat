//
//  ConversationThreadTableViewCell.swift
//  TravChat
//
//  Created by Tyler on 7/13/16.
//  Copyright © 2016 Tyler. All rights reserved.
//

import UIKit

class ConversationThreadTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    var delegate: ConversationTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func nameButtonTapped(sender: AnyObject) {
        delegate?.nameButtonTapped(self)
    }
    
}

extension ConversationThreadTableViewCell {
    func updateMessages(message: Message) {
       
        displayNameLabel.text = message.displayName
        timeLabel.text = message.timestamp.dateFormat()
        messageLabel.text = message.message
    }
    
}

protocol ConversationTableViewCellDelegate {
    func nameButtonTapped(cell: ConversationThreadTableViewCell)
}