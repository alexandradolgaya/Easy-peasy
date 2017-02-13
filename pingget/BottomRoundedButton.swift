//
//  BottomRoundedButton.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/25/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class BottomRoundedButton: UIButton {
    static let cornerRadius: CGFloat = 8
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let cornerRadius = frame.height / 2
        let path = UIBezierPath(roundedRect:bounds,
                                byRoundingCorners: [.bottomLeft, .bottomRight],
                                cornerRadii: CGSize(width: cornerRadius,
                                                    height: cornerRadius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
}
