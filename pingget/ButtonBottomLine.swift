//
//  ButtonBottomLine.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/17/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class ButtonBottomLine: UIButton {
    override func draw(_ rect: CGRect) {
        TextFieldBottomLine.drawBottomLine(rect: rect)
    }
}
