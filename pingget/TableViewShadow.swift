//
//  TableViewShadow.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/15/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class TableViewShadow: UITableView {
    override func awakeFromNib() {
        setShadow()
    }
    
    private func setShadow() {
        ViewShadow.setShadow(view: self, shadowColor: ViewShadow.blueShadowColor)
        layer.masksToBounds = false
    }
}
