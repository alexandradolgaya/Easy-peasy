//
//  ViewController.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/11/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class StartVC: UIViewController {
    
    @IBOutlet weak var startView : ViewShadow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startView.layer.cornerRadius = 4.0
    }
    
    @IBAction func createRequest(_ sender: AnyObject) {
        UserDefaults.standard.set(false, forKey: "Authorized")
        UserDefaults.standard.set("user", forKey: "user_type")
    }
    
}

