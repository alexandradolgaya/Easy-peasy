//
//  SetupVC.swift
//  pingget
//
//  Created by Victor on 20.12.16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class SetupVC: NavBarVC {

    @IBOutlet weak var infoView : ViewShadow!
    
    static let id = "SetupVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoView.layer.cornerRadius = 4.0
    }
}
