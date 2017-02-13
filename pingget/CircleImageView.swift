//
//  CircleImageView.swift
//  pingget
//
//  Created by Victor on 03.01.17.
//  Copyright © 2017 Steelkiwi. All rights reserved.
//

import UIKit

class CircleImageView: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        setCornerRadius()
    }
    
    private func setCornerRadius() {
        layer.cornerRadius = frame.width / 2
    }

}
