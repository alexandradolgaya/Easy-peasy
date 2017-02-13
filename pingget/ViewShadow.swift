//
//  ViewShadow.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/14/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class ViewShadow: UIView {
    static let blueShadowColor = UIColor(redInt: 179, greenInt: 207, blueInt: 221)
    static let shadowRadius: CGFloat = 3
    static let shadowOffset = CGSize(width: 0, height: 3)
    static let shadowOpacity: Float = 0.5
    
    @IBInspectable
    var shadowColor: UIColor = ViewShadow.blueShadowColor
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setShadow()
    }
    
    static func setShadow(view: UIView, shadowColor: UIColor = ViewShadow.blueShadowColor) {
        view.layer.shadowColor = shadowColor.cgColor
        view.layer.shadowRadius = ViewShadow.shadowRadius
        view.layer.shadowOffset = ViewShadow.shadowOffset
        view.layer.shadowOpacity = ViewShadow.shadowOpacity
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
    }
    
    private func setShadow() {
        ViewShadow.setShadow(view: self, shadowColor: shadowColor)
    }
}
