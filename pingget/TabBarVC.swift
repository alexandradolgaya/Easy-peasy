//
//  TabBarVC.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/29/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

protocol TabBarChildVC {
    static func create() -> UIViewController?
}

class TabBarVC: UITabBarController {
    private var containerView: UIView?
    var isSupplier: Bool = false
    
    static let myRequestsId = "MyRequestsVC"
    static let myClientsId = "MyClientsVC"
    
    var childVCTypes: [MyRequestsVC.Type] {
        return [MyRequestsVC.Type]()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.isHidden = true
        self.initViewControllers()
//        addTabBarView()
        isSupplier == true ? showMyClients() : showMyRequests()
//        showFirstChildVC()
    }
    
    private func addTabBarView() {
//        guard let tabBarView = self.view.viewWithTag(1) else {return}
//        self.view.addSubview(tabBarView)
            let tabbarView = UIView.init(frame: CGRect.init(x: 0, y: 200, width: 375, height: 100))
        self.view.addSubview(tabbarView)
    }
    
    internal func initViewControllers() {
        let userStoryboard = UIStoryboard.init(name: "User", bundle: nil)
        let requestVC = userStoryboard.instantiateViewController(withIdentifier: TabBarVC.myRequestsId)
        let createRequestStoryboard = UIStoryboard.init(name: "CreateRequest", bundle: nil)
        let createRequestVC = createRequestStoryboard.instantiateInitialViewController()
        let chatsStoryboard = UIStoryboard.init(name: "Chats", bundle: nil)
        let chatsVC = chatsStoryboard.instantiateInitialViewController()
        var viewControllers = [requestVC, chatsVC!, createRequestVC!]
        if isSupplier == true {
            let supplierStoryboard = UIStoryboard.init(name: "Supplier", bundle: nil)
            let supplierVC = supplierStoryboard.instantiateViewController(withIdentifier: TabBarVC.myClientsId)
            viewControllers.insert(supplierVC, at: 0)
        }
        self.setViewControllers(viewControllers, animated: false)
    }
    
    func showMyRequests() {
        selectedViewController = isSupplier == true ? viewControllers?[1] : viewControllers?[0]
    }
    
    func showCreateRequest() {
        selectedViewController = isSupplier == true ? viewControllers?[3] : viewControllers?[2]
    }
    
    func showChats() {
        selectedViewController = isSupplier == true ? viewControllers?[2] : viewControllers?[1]
    }
    
    func showMyClients() {
        selectedViewController = viewControllers?[0]
    }
    
    private func showFirstChildVC() {
        showChildVC(index: 0)
    }
    
    private func initContainerView() {
        let containerViewTag = 1
        containerView = view.subviews.filter({ $0.tag == containerViewTag }).first
    }
    
    private func showChildVC(index: Int) {
        guard let childVC = childVCTypes[index].create() else { return }
        childViewControllers.first?.removeFromParentViewController()
        addChildViewController(childVC)
        containerView?.addSubview(childVC.view)
        childVC.didMove(toParentViewController: self)
    }
}
