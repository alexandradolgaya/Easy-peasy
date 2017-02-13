//
//  SupplierTabBarVC.swift
//  pingget
//
//  Created by Victor on 29.12.16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class SupplierTabBarVC: BaseVC {
    
    var tabBarVC: TabBarVC?
    @IBOutlet weak var createRequestButton: UIButton!
    @IBOutlet weak var myClientIcon: UIImageView!
    @IBOutlet weak var myClientButton: UIButton!
    @IBOutlet weak var myRequestsIcon: UIImageView!
    @IBOutlet weak var myRequestsButton: UIButton!
    @IBOutlet weak var myChatsIcon: UIImageView!
    @IBOutlet weak var myChatsButton: UIButton!
    @IBOutlet weak var myAccountIcon: UIImageView!
    @IBOutlet weak var myAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createRequestButton.layer.cornerRadius = createRequestButton.bounds.size.width / 2
        myClientIcon.image = UIImage.init(named: "icn_my_clients_selected")
        myClientButton.setTitleColor(UIColor.pinggetOrange(), for: UIControlState.normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TabBarSeque" {
            guard let tabBar = segue.destination as? TabBarVC else {
                return
            }
            tabBarVC = tabBar
            tabBar.isSupplier = true
        }
    }
    
    @IBAction func showMyClients(_ sender: AnyObject) {
        NotificationCenter.default.post(name: notificationName, object: nil)
        if myClientIcon.image == UIImage.init(named: "icn_my_clients") {
            myClientIcon.image = UIImage.init(named: "icn_my_clients_selected")
            myClientButton.setTitleColor(UIColor.pinggetOrange(), for: UIControlState.normal)
            myRequestsIcon.image = UIImage.init(named: "icn_my_requests")
            myRequestsButton.setTitleColor(UIColor.pinggetBlack(), for: UIControlState.normal)
            myChatsIcon.image = UIImage.init(named: "icn_chat")
            myChatsButton.setTitleColor(UIColor.pinggetBlack(), for: UIControlState.normal)
        }
        tabBarVC!.showMyClients()
    }
    
    @IBAction func showMyRequest(_ sender: AnyObject) {
        NotificationCenter.default.post(name: notificationName, object: nil)
        // FIXME: Refactor on real build
        if myRequestsIcon.image == UIImage.init(named: "icn_my_requests") {
            myRequestsIcon.image = UIImage.init(named: "icn_my_requests_selected")
            myRequestsButton.setTitleColor(UIColor.pinggetOrange(), for: UIControlState.normal)
            myChatsIcon.image = UIImage.init(named: "icn_chat")
            myChatsButton.setTitleColor(UIColor.pinggetBlack(), for: UIControlState.normal)
            myClientIcon.image = UIImage.init(named: "icn_my_clients")
            myClientButton.setTitleColor(UIColor.pinggetBlack(), for: UIControlState.normal)
        }
        tabBarVC!.showMyRequests()
    }
    
    @IBAction func showCreateRequest(_ sender: AnyObject) {
        NotificationCenter.default.post(name: notificationName, object: nil)
        tabBarVC!.showCreateRequest()
    }
    
    @IBAction func showChats(_ sender: AnyObject) {
        NotificationCenter.default.post(name: notificationName, object: nil)
        // FIXME: Refactor on real build
        if myChatsIcon.image == UIImage.init(named: "icn_chat") {
            myChatsIcon.image = UIImage.init(named: "icn_chat_selected")
            myChatsButton.setTitleColor(UIColor.pinggetOrange(), for: UIControlState.normal)
            myRequestsIcon.image = UIImage.init(named: "icn_my_requests")
            myRequestsButton.setTitleColor(UIColor.pinggetBlack(), for: UIControlState.normal)
            myClientIcon.image = UIImage.init(named: "icn_my_clients")
            myClientButton.setTitleColor(UIColor.pinggetBlack(), for: UIControlState.normal)
        }
        tabBarVC!.showChats()
    }
    
}
