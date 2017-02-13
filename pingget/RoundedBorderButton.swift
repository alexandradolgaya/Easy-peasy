//
//  RoundedBorderButton.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/11/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class RoundedBorderButton: RoundedButton {
    
    @IBInspectable
    var borderColor : UIColor = UIColor.white
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setBorder()
    }
    
    private func setBorder() {
        layer.borderWidth = 2
        layer.borderColor = borderColor.cgColor
    }
}
