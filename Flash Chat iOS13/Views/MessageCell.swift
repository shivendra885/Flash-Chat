//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by Shivendra pratap singh on 01/02/24.
//  Copyright © 2024 Angela Yu. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var messageBackView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var youImageView: UIImageView!
    
    override func awakeFromNib() {
        messageLabel.text = ""
        messageBackView.layer.cornerRadius = messageBackView.frame.size.height/5
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
