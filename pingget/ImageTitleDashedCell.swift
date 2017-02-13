//
//  ImageTitleDashedCell.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/28/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class ImageTitleDashedCell: UITableViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    static let id = "ImageTitleDashedCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photoImageView.clipsToBounds = true
        photoImageView.layer.cornerRadius = photoImageView.frame.height / 2.0
    }
    
    func setData(imageUrl: String, title: String) {
        titleLabel.text = title
        photoImageView.image = UIImage.init(named: imageUrl)
    }
}
