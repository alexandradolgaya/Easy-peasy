//
//  BottomRoundedView.swift
//  pingget
//
//  Created by Igor P on 11/20/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class BottomRoundedView: SpecifiedCornersRoundedView {
    override var roundingCorners: UIRectCorner { return [.bottomLeft, .bottomRight] }
}
