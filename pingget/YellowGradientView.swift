//
//  YellowGradientView.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/18/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class YellowGradientView: GradientView {
    override func awakeFromNib() {
        super.awakeFromNib()
        startColor = UIColor(hex: "#FFC700")
        endColor = UIColor(hex: "#FF9600")
    }
}
