//
//  UserTabBarVC.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/29/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit
import Foundation

let notificationName = Notification.Name("closeMyDetails")

class UserTabBarVC: BaseVC {
    
    var tabBarVC: TabBarVC?
    @IBOutlet weak var createRequestButton: UIButton!
    @IBOutlet weak var myRequestsIcon: UIImageView!
    @IBOutlet weak var myRequestsButton: UIButton!
    @IBOutlet weak var myChatsIcon: UIImageView!
    @IBOutlet weak var myChatsButton: UIButton!
    @IBOutlet weak var myAccountIcon: UIImageView!
    @IBOutlet weak var myAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createRequestButton.layer.cornerRadius = createRequestButton.bounds.size.width / 2
        myRequestsIcon.image = UIImage.init(named: "icn_my_requests_selected")
        myRequestsButton.setTitleColor(UIColor.pinggetOrange(), for: UIControlState.normal)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TabBarSeque" {
            guard let tabBar = segue.destination as? TabBarVC else {
                return
            }
            tabBarVC = tabBar
        }
    }
    
    @IBAction func showMyRequest(_ sender: AnyObject) {
        // FIXME: Refactor on real build
        NotificationCenter.default.post(name: notificationName, object: nil)
        if myRequestsIcon.image == UIImage.init(named: "icn_my_requests") {
            myRequestsIcon.image = UIImage.init(named: "icn_my_requests_selected")
            myRequestsButton.setTitleColor(UIColor.pinggetOrange(), for: UIControlState.normal)
            myChatsIcon.image = UIImage.init(named: "icn_chat")
            myChatsButton.setTitleColor(UIColor.pinggetBlack(), for: UIControlState.normal)
        }
        tabBarVC!.showMyRequests()
    }
    
    @IBAction func showCreateRequest(_ sender: AnyObject) {
        NotificationCenter.default.post(name: notificationName, object: nil)
        tabBarVC!.showCreateRequest()
    }
    
    @IBAction func showChats(_ sender: AnyObject) {
        // FIXME: Refactor on real build
        NotificationCenter.default.post(name: notificationName, object: nil)
        if myChatsIcon.image == UIImage.init(named: "icn_chat") {
            myChatsIcon.image = UIImage.init(named: "icn_chat_selected")
            myChatsButton.setTitleColor(UIColor.pinggetOrange(), for: UIControlState.normal)
            myRequestsIcon.image = UIImage.init(named: "icn_my_requests")
            myRequestsButton.setTitleColor(UIColor.pinggetBlack(), for: UIControlState.normal)
        }
        tabBarVC!.showChats()
    }
    
}
