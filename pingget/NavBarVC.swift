//
//  NavBarVC.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/14/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class NavBarVC: BaseVC {
    
    private var navBar: UIView?
    private var titleLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavBar()
    }
    
    override var title: String? {
        didSet {
            setTitle()
        }
    }
    
    private func initNavBar() {
        let navBarTag = 1
        let backButtonTag = 1
        let titleLabelTag = 2
        navBar = view.subviews.filter({ $0.tag == navBarTag }).first
        let backButton = navBar?.subviews.filter({ $0.tag == backButtonTag }).first as? UIButton
        titleLabel = navBar?.subviews.filter({ $0.tag == titleLabelTag }).first as? UILabel
        setTitle()
        backButton?.addTarget(self, action: #selector(backTapped(_:)), for: .touchUpInside)
    }
    
    private func setTitle() {
        titleLabel?.text = title
    }
    
    func back() {
        if let nav = navigationController {
            nav.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func backTapped(_ sender: AnyObject) {
        back()
    }
    
    @IBAction func backAction(_ sender: AnyObject) {
        back()
    }
    
    @IBAction func loginTapped(_ sender: AnyObject) {
        showLoginVC()
    }
    
    func showLoginVC() {
        let loginVC = navigationController?.viewControllers.filter({ $0 is LoginVC }).first
        
        if let loginVC = loginVC, loginVC.isMember(of: LoginVC.self) {
            let _ = navigationController?.popToViewController(loginVC, animated: true)
        } else if let vc = BaseVC.createVC(storyboard: .signUp,vcId: LoginVC.id) {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func showVC(vc: UIViewController?) {
        guard let vc = vc else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
}
