//
//  RoundedView.swift
//  pingget
//
//  Created by Borys Khliebnikov on 1/4/17.
//  Copyright © 2017 Steelkiwi. All rights reserved.
//

import UIKit

class RoundedView: UIView {
    let cornerRadius: CGFloat = 7
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setRoundedCorners()
    }
    
    private func setRoundedCorners() {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: super.intrinsicContentSize.width + cornerRadius * 2,
                      height: super.intrinsicContentSize.height/* + cornerRadius*/)
    }
}
