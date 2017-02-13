//
//  DemoConversation.swift
//  SwiftExample
//
//  Created by Dan Leonard on 5/11/16.
//  Copyright © 2016 MacMeDan. All rights reserved.
//

//import JSQMessagesViewController

// User Enum to make it easyier to work with.
enum DemoUser: String {
    case me    = "0"
    case Salvador    = "1"
}

// Helper Function to get usernames for a secific DemoUser.
func getName(_ user: DemoUser) -> String{
    switch user {
    case .me:
        return "Me"
    case .Salvador:
        return "Salvador Colon"
    }
}
//// Create Names to display
//let DisplayNameSquires = "Jesse Squires"
//let DisplayNameLeonard = "Dan Leonard"
//let DisplayNameCook = "Tim Cook"
//let DisplayNameJobs = "Steve Jobs"
//let DisplayNameWoz = "Steve Wazniak"



// Create Unique IDs for avatars
let AvatarIDMe = "0"
let AvatarIDSalvador = "1"

// Create Avatars Once for performance
//
// Create an avatar with Image

let AvatarMe = JSQMessagesAvatarImageFactory().avatarImage(with: UIImage.init(named: "icon_female")!)

let AvatarSalvador = JSQMessagesAvatarImageFactory().avatarImage(with: UIImage.init(named: "icon_male")!)


// Helper Method for getting an avatar for a specific DemoUser.
func getAvatar(_ id: String) -> JSQMessagesAvatarImage{
    let user = DemoUser(rawValue: id)!
    
    switch user {
    case .me:
        return AvatarMe
    case .Salvador:
        return AvatarSalvador
    }
}



// INFO: Creating Static Demo Data. This is only for the exsample project to show the framework at work.
//var conversationsList = [Conversation]()
//
//var convo = Conversation(firstName: "Steave", lastName: "Jobs", preferredName:  "Stevie", smsNumber: "(987)987-9879", id: "33", latestMessage: "Holy Guacamole, JSQ in swift", isRead: false)

let message1 = JSQMessage(senderId: AvatarIDSalvador, displayName: getName(DemoUser.Salvador), text: "I can offer you a manicure and laser hair removal on fingers")
let message2 = JSQMessage(senderId: AvatarIDMe, displayName: getName(DemoUser.me), text: "That would be great!")

func makeNormalConversation() -> [JSQMessage] {
    let conversation = [message1, message2]
    return conversation
}
