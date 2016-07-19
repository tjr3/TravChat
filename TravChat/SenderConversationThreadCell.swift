//
//  senderConversationThreadCell.swift
//  TravChat
//
//  Created by Tyler on 7/18/16.
//  Copyright © 2016 Tyler. All rights reserved.
//
import UIKit


class SenderConversationThreadCell: UITableViewCell {
    
    @IBOutlet weak var cuDisplayNameLabel: UILabel!
    @IBOutlet weak var cuTimeLabel: UILabel!
    @IBOutlet weak var cuMessageLabel: UILabel!
    
    var delegate: SenderConversationThreadCellDelegate?
}

extension SenderConversationThreadCell {
    func updateMessage(message: Message) {
        
        if let displayName = message.displayName {
            cuDisplayNameLabel.text = displayName
        }
        
        cuTimeLabel.text = message.timestamp.secondaryDateFormat()
        cuMessageLabel.text = message.message
    }
}


protocol SenderConversationThreadCellDelegate {
    func senderCell(cell: SenderConversationThreadCell)
}