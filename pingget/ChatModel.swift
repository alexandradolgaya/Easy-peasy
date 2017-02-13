//
//  ChatModel.swift
//  pingget
//
//  Created by Victor on 03.01.17.
//  Copyright © 2017 Steelkiwi. All rights reserved.
//

import Foundation

class ChatModel: NSObject {
    
    var authorName : String? = nil
    var authorImage : String? = nil
    var lastMessage : String? = nil
    var messageTime : Date? = nil
    var isRead : Bool? = nil
    
    convenience init(authorName : String? = nil, authorImage : String? = nil, lastMessage : String? = nil, messageTime : Date? = nil, isRead : Bool? = nil) {
        self.init()
        self.authorName = authorName
        self.authorImage = authorImage
        self.lastMessage = lastMessage
        self.messageTime = messageTime
        self.isRead = isRead
    }
    
}
