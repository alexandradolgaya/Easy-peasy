//
//  ChatListCell.swift
//  pingget
//
//  Created by Victor on 03.01.17.
//  Copyright © 2017 Steelkiwi. All rights reserved.
//

import UIKit

class ChatListCell: UITableViewCell {
    
    @IBOutlet weak var avatarView: CircleImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var unreadView: CircleView!
    @IBOutlet weak var onlineView: UIView!
    
    static let id = "ChatListCell"
    let timeFormat = "HH:mm"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        onlineView.isHidden = true
        onlineView.layer.borderColor = UIColor.white.cgColor
        onlineView.layer.borderWidth = 1.0
    }
    
    func setChatData(chat: ChatModel) {
        avatarView.image = UIImage.init(named: chat.authorImage!)
        nameLabel.text = chat.authorName
        messageLabel.text = chat.lastMessage
        timeLabel.text = formattedTime(chat.messageTime!)
        unreadView.isHidden = chat.isRead!
    }
    
    private func formattedTime(_ time: Date) -> String {
        return time.toString(dateFormat: timeFormat)
    }
    
    override func prepareForReuse() {
        onlineView.isHidden = true
    }
    
}
