//
//  CircleView.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/22/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class CircleView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setCornerRadius()
    }
    
    private func setCornerRadius() {
        layer.cornerRadius = frame.width / 2
    }
}
