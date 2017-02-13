//
//  SpecifiedCornersRoundedView.swift
//  pingget
//
//  Created by Igor P on 11/20/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class SpecifiedCornersRoundedView: UIView {
    static let cornerRadius: CGFloat = 8
    
    var roundingCorners: UIRectCorner { return [] }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let path = UIBezierPath(roundedRect:bounds,
                                byRoundingCorners: roundingCorners,
                                cornerRadii: CGSize(width: TopRoundedView.cornerRadius,
                                                    height: TopRoundedView.cornerRadius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
}

