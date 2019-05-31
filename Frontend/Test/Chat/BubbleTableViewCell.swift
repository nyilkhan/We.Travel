//
//  BubbleTableViewCell.swift
//  Test
//
//  Created by David on 3/27/19.
//  Copyright © 2019 David. All rights reserved.
//

import UIKit

class BubbleTableViewCell: UITableViewCell {

    let messageLabel = UILabel()
    let bubbleBackgroundView = UIView()
    
    var chatMessage: ChatMessage!
    {
        didSet
        {
            bubbleBackgroundView.backgroundColor = chatMessage.isIncoming ? .white : UIColor(red: 0, green: 0.8, blue: 0, alpha: 0.8)
            messageLabel.text = chatMessage.text
            
            if chatMessage.isIncoming
            {
                leadingConstraint.isActive = true
                trailingConstraint.isActive = false
            }
            else
            {
                leadingConstraint.isActive = false
                trailingConstraint.isActive = true
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        bubbleBackgroundView.backgroundColor = .white
        
        bubbleBackgroundView.layer.cornerRadius = 12
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bubbleBackgroundView)
        
        addSubview(messageLabel)
        messageLabel.numberOfLines = 0
//        messageLabel.text = "This is a extremely long line that should be able to get to the second line or even the third line"
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        let constraints =
        [
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 26),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -26),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
        
            bubbleBackgroundView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
            bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16),
            bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 16)
        ]
        
        NSLayoutConstraint.activate(constraints)
        leadingConstraint = messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        leadingConstraint.isActive = false
        
        trailingConstraint = messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        trailingConstraint.isActive = true
        
        messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
    }
    
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) has not been implemented")
    }
}
