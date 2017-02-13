//
//  RequestResponseCell.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/22/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class RequestResponseCell: UITableViewCell {
    static let id = "RequestResponseCell"
    @IBOutlet weak var responserImageView: UIImageView!
    @IBOutlet weak var responserNameLabel: UILabel!
    @IBOutlet weak var responserTimeLabel: UILabel!
    @IBOutlet weak var responserComment: UILabel!
    @IBOutlet weak var responserCircleView: CircleView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func configureWithUser(user: User, comment: String) {
        responserImageView.image = UIImage.init(named: user.imageUrl)
        responserNameLabel.text = user.name
        responserComment.text = comment
    }
}
