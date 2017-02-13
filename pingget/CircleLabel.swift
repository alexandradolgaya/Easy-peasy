//
//  CircleLabel.swift
//  pingget
//
//  Created by Victor on 19.12.16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class CircleLabel: UILabel {
    
    var outerLayer: CAShapeLayer!
    var mainLayer: CAShapeLayer!
    
    @IBInspectable
    var viewShadowColor: UIColor = UIColor.white
    
    @IBInspectable
    var viewMainColor: UIColor = UIColor.white
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setCornerRadius()
        drawOuterCircle()
        drawMainCircle()
    }
    
    private func setCornerRadius() {
        clipsToBounds = true
        layer.cornerRadius = frame.width / 2
    }
    
    private func drawOuterCircle() {
        outerLayer = CAShapeLayer()
        let radius: CGFloat = bounds.size.width / 2
        outerLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2)  , cornerRadius: radius).cgPath
        outerLayer.position = CGPoint(x: frame.midX - radius, y: frame.midY - radius)
        outerLayer.fillColor = viewShadowColor.cgColor
        superview?.layer.insertSublayer(outerLayer, below: self.layer)
    }
    
    private func drawMainCircle() {
        mainLayer = CAShapeLayer()
        let radius: CGFloat = bounds.size.width / 2
        mainLayer.path = UIBezierPath(roundedRect: CGRect(x: 2, y: 2, width: radius * 2 - 4.0, height: radius * 2 - 4.0)  , cornerRadius: radius).cgPath
        mainLayer.position = CGPoint(x: frame.midX - radius, y: frame.midY - radius)
        mainLayer.fillColor = viewMainColor.cgColor
        superview?.layer.insertSublayer(mainLayer, below: self.layer)
    }
    
}
