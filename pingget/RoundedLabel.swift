//
//  RoundedLabel.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/22/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class RoundedLabel: UILabel {
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
