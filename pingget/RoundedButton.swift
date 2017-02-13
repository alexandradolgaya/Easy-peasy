//
//  RoundedButton.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/11/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    
    @IBInspectable
    var startColor: UIColor? {
        didSet {
            setGradientColors()
        }
    }
    
    @IBInspectable
    var endColor: UIColor? {
        didSet {
            setGradientColors()
        }
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    var gradientLayer: CAGradientLayer? {
        return layer as? CAGradientLayer
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeRoundedCorners()
        setGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        makeRoundedCorners()
    }
    
    private func makeRoundedCorners() {
        layer.cornerRadius = frame.height / 2
    }
    
    private func setGradient() {
        setGradientColors()
        gradientLayer?.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer?.endPoint = CGPoint(x: 1.0, y: 1.0)
    }
    
    private func setGradientColors() {
        guard let startColor = startColor, let endColor = endColor else { return }
        let colors: Array<AnyObject> = [startColor.cgColor, endColor.cgColor]
        gradientLayer?.colors = colors
    }
}
