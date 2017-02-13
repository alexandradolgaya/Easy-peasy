//
//  AvatarCircleView.swift
//  pingget
//
//  Created by Borys Khliebnikov on 1/9/17.
//  Copyright © 2017 Steelkiwi. All rights reserved.
//

import Foundation
import UIKit

class AvatarCircleView: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setCornerRadius()
    }
    
    private func setCornerRadius() {
        layer.cornerRadius  = frame.width / 2
        layer.masksToBounds = true
        layer.borderWidth   = 2.0
        layer.borderColor   = UIColor.white.cgColor
    }
}
