//
//  InformPopup.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/24/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class InformPopup: BasePopupVC {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    private static let id = "InformPopup"
    
    private var message: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private func updateUI() {
        titleLabel.text = title
        messageLabel.text = message
    }
    
    static func show(fromVC: UIViewController, title: String, message: String) {
        let popup = create(popupId: id) as! InformPopup
        popup.setData(title: title, message: message)
        popup.show(fromVC: fromVC)
    }
    
    func setData(title: String, message: String) {
        self.title = title
        self.message = message
    }
    
    @IBAction func closeTapped(_ sender: AnyObject) {
        close()
    }
}
