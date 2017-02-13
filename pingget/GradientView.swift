//
//  GradientView.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/18/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class GradientView: UIView {
    @IBInspectable
    var startColor: UIColor? {
        didSet {
            GradientView.setGradientColors(layer: gradientLayer, startColor: startColor, endColor: endColor)
        }
    }
    
    @IBInspectable
    var endColor: UIColor? {
        didSet {
            GradientView.setGradientColors(layer: gradientLayer, startColor: startColor, endColor: endColor)
        }
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    var gradientLayer: CAGradientLayer? {
        return layer as? CAGradientLayer
    }
    
    override func awakeFromNib() {
        GradientView.setGradient(layer: gradientLayer)
    }
    
    static func setGradient(layer: CAGradientLayer?) {
        layer?.startPoint = CGPoint(x: 0.0, y: 1.0)
        layer?.endPoint = CGPoint(x: 1.0, y: 1.0)
    }
    
    static func setGradientColors(layer: CAGradientLayer?, startColor: UIColor?, endColor: UIColor?) {
        guard let startColor = startColor, let endColor = endColor else { return }
        let colors: Array<AnyObject> = [startColor.cgColor, endColor.cgColor]
        layer?.colors = colors
    }
}
