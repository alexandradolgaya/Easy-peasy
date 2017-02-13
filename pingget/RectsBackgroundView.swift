//
//  RectsBackgroundView.swift
//  pingget
//
//  Created by Igor P on 11/20/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class RectsBackgroundView: UIView {
    var backRectLayer: CAShapeLayer?
    var frontRectLayer: CAShapeLayer?
    
    override func layoutSubviews() {
        setBackground()
    }
    
    private func setBackground() {
        let halfHeight = frame.height / 2
        let horizontalMargin = frame.width * 0.1
        setRoundedLayerParams(layer: &backRectLayer,
                              horizontalMargin: horizontalMargin,
                              verticalMargin: 0)
        setRoundedLayerParams(layer: &frontRectLayer,
                              horizontalMargin: horizontalMargin / 2,
                              verticalMargin: halfHeight)
    }
    
    private func setRoundedLayerParams(layer: inout CAShapeLayer?, horizontalMargin: CGFloat, verticalMargin: CGFloat) {
        layer?.removeFromSuperlayer()
        let rect = CGRect(x: horizontalMargin, y: verticalMargin, width: bounds.width - horizontalMargin * 2, height: bounds.height - verticalMargin)
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners:[.topLeft, .topRight],
                                cornerRadii: CGSize(width: SpecifiedCornersRoundedView.cornerRadius,
                                                    height: SpecifiedCornersRoundedView.cornerRadius))
        
        layer = CAShapeLayer()
        guard let layer = layer else { return }
        layer.path = path.cgPath
        layer.fillColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.3).cgColor
        self.layer.addSublayer(layer)
    }
}
