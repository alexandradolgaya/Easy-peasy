//
//  HeaderFilledIndicatorView.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/15/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

protocol HeaderFilledIndicatorCellDelegate: class {
    func sectionPressed(section: Int)
}

class HeaderFilledIndicatorCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var filledIndicatorImageView: UIImageView!
    @IBOutlet weak var sectionButton: SectionButton!
    
    static let id = "HeaderFilledIndicatorCell"
    var section: Int?
    weak var delegate: HeaderFilledIndicatorCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(header: HeaderFilledIndicator, indexPath: IndexPath?) {
        titleLabel.text = header.title
        if let ip = indexPath {
            sectionButton.parentCellIndexPath = ip
        }
        filledIndicatorImageView.image = header.filled ? UIImage.init(named: "icon_checked") : UIImage.init(named: "icon_plus")
    }
    
    func setData(title: String, filled: Bool?) {
        titleLabel.text = title
        if let fl = filled {
            filledIndicatorImageView.image = fl ? UIImage.init(named: "icon_checked") : UIImage.init(named: "icon_plus")
        }
    }
    
    @IBAction func sectionPressed(_ sender: Any) {
        if let sc = section {
            self.delegate?.sectionPressed(section: sc)
        }

    }
}
