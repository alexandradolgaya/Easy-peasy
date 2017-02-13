//
//  ForgotPasswordVC.swift
//  pingget
//
//  Created by Victor on 20.12.16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class ForgotPasswordVC: NavBarVC {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var forgotView : ViewShadow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewsForKeyboard()
        forgotView.layer.cornerRadius = 4.0
    }
    
    private func setViewsForKeyboard() {
        scrollViewForKeyboard = scrollView
    }

}
