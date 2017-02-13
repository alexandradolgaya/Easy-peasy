//
//  selectionItemCell.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/15/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class SelectionItemCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var selectedIndicatorImageView: UIImageView!
    
    static let id = "SelectionItemCell"
    
    func setData(selectionItem: SelectionItem) {
        titleLabel.text = selectionItem.title
        selectedIndicatorImageView.image = selectionItem.selected ? UIImage.init(named: "icon_selected") : UIImage.init(named: "icon_not_selected")
        iconImageView.image = UIImage.init(named: selectionItem.imageName)
    }
}
