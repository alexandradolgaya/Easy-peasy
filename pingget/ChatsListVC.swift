//
//  ChatsListVC.swift
//  pingget
//
//  Created by Victor on 03.01.17.
//  Copyright © 2017 Steelkiwi. All rights reserved.
//

import UIKit

class ChatsListVC: NavBarVC {

    var chats: [ChatModel] = [ChatModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createChats()
        
    }
    
    private func createChats() {
        chats = [ChatModel.init(authorName: "Salvador Colon", authorImage: "fake_avatar", lastMessage: "I need a manicured nails and laser hair removal on fingers.", messageTime: Date.init(), isRead: false),
        ChatModel.init(authorName: "Nathan Palmer", authorImage: "fake_avatar2", lastMessage: "Hi Amanda! I am an experienced Hair & Skin beautician with around 7 years expericnce", messageTime: Date.init(), isRead: false),
        ChatModel.init(authorName: "Fred Carson", authorImage: "fake_avatar1", lastMessage: "I need a manicured nails and laser hair removal on fingers.", messageTime: Date.init(), isRead: true),
        ChatModel.init(authorName: "Ann Arnold", authorImage: "fake_avatar4", lastMessage: "Are you located in a congestion zone within the city ?", messageTime: Date.init(), isRead: false)
        ,ChatModel.init(authorName: "Winston Lamb", authorImage: "fake_avatar3", lastMessage: "Hi Amanda! I am an experienced Hair & Skin beautician with around 7 years expericnce", messageTime: Date.init(), isRead: true)
        ,ChatModel.init(authorName: "Margaret Gomez", authorImage: "fake_avatar7", lastMessage: "I need a manicured nails and laser hair removal on fingers.", messageTime: Date.init(), isRead: true)
        ,ChatModel.init(authorName: "Salvador Colon", authorImage: "fake_avatar6", lastMessage: "I need a manicured nails and laser hair removal on fingers.", messageTime: Date.init(), isRead: true)
        ,ChatModel.init(authorName: "Nathan Palmer", authorImage: "fake_avatar5", lastMessage: "Hi Amanda! I am an experienced Hair & Skin beautician with around 7 years expericnce", messageTime: Date.init(), isRead: true)]
    }
}

extension ChatsListVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatListCell.id) as? ChatListCell else {return UITableViewCell()}
        cell.setChatData(chat: chats[indexPath.row])
        if indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 5 {
            cell.onlineView.isHidden = false
        }
        return cell
    }
    
}

extension ChatsListVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let chatView = ChatViewController()
        chatView.messages = makeNormalConversation()
        let chatNavigationController = UINavigationController(rootViewController: chatView)
        self.navigationController?.pushViewController(chatView, animated: false)
    }
}
