//
//  RequestCell.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/22/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class RequestCell: UITableViewCell {
    @IBOutlet weak var requestStatusView: UIView!
    @IBOutlet weak var serviceIconImageView: UIImageView!
    @IBOutlet weak var targetUserImageView: UIImageView!
    @IBOutlet weak var servicesTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var noAnswersLabel: UILabel!
    @IBOutlet weak var avatarsView: UIView!
    @IBOutlet weak var fakeAv1: AvatarCircleView!
    @IBOutlet weak var fakeAv2: AvatarCircleView!
    @IBOutlet weak var fakeAv3: AvatarCircleView!
    
    static let id = "RequestCell"
    static let extendedId = "RequestCellExtended"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let av = avatarsView {
            av.isHidden = true
        }
    }
    
    func setData(request: Request) {
        let icon = request.forWho.first?.title == "Female" ? "icon_female_small" : "icon_male_small"
        targetUserImageView.image = UIImage.init(named: icon)
        serviceIconImageView.image = UIImage.init(named: (request.services.first?.imageName)!)
        servicesTitleLabel.text = request.servicesFormatted
        dateLabel.text = request.date?.startDateAndTimeFormatted
        locationLabel.text = request.location?.descriptionForUser
        if request.simulationResponser.count > 0 {
            fakeAv1.image = UIImage.init(named: request.simulationResponser[0].imageUrl)
            fakeAv2.image = UIImage.init(named: request.simulationResponser[1].imageUrl)
            fakeAv3.image = UIImage.init(named: request.simulationResponser[2].imageUrl)
            configureForSumulation()
        }
    }
    
    func configureForSumulation() {
        avatarsView.isHidden = false
        noAnswersLabel.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if let av = avatarsView {
            av.isHidden = true
        }
        if let nl = noAnswersLabel {
            nl.isHidden = false
        }
    }
}
