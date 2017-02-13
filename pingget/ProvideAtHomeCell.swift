//
//  ProvideAtHomeCell.swift
//  pingget
//
//  Created by Victor on 22.12.16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class ProvideAtHomeCell: UITableViewCell {
    
    @IBOutlet weak var checkbox : UIImageView!
    @IBOutlet weak var label: UILabel!

    static let id = "ProvideAtHomeCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setText(service: Bool) {
        label.text = service == true ? "I provide at client home services" : "I provide home delivery"
    }

    func setSelected(selected: Bool) {
        checkbox.image = selected == true ? UIImage.init(named: "icon_selected") : UIImage.init(named: "icon_not_selected")
    }
    
}
