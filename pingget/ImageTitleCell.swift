//
//  ServiceCell.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/15/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class ImageTitleCell: UITableViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLeadingConstraint: NSLayoutConstraint!
    
    static let id = "ImageTitleCell"
    
    override func awakeFromNib() {
        disableSelectionColor()
    }
    
    private func disableSelectionColor() {
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = UIColor.clear
        self.selectedBackgroundView = selectedBackgroundView
    }
    
    private func layoutTitle() {
        if let _ = iconImageView.image {
            imageHeightConstraint.constant = 50.0
            titleLeadingConstraint.constant = 30.0
        }
        else {
            imageHeightConstraint.constant = 0.0
            titleLeadingConstraint.constant = 0.0
        }
    }
    
    func clearData() {
        titleLabel.text = ""
        iconImageView.image = nil
        layoutTitle()
        layoutSubviews()
    }
    
    func setData(businessType: BusinessType? = nil, businessCategory: BusinessCategory? = nil, service: Service? = nil, targetUser: TargetUser? = nil) {
        if let businessType = businessType {
            titleLabel.text = businessType.title
            iconImageView.image = UIImage.init(named: businessType.imageName)
        } else if let businessCategory = businessCategory {
            titleLabel.text = businessCategory.title
            iconImageView.image = UIImage.init(named: businessCategory.imageName)
        } else if let service = service {
            titleLabel.text = service.title
            iconImageView.image = UIImage.init(named: service.imageName)
        } else if let targetUser = targetUser {
            titleLabel.text = targetUser.title
            iconImageView.image = UIImage.init(named: targetUser.imageName)
        } else {
            // Removed = "Not selected yet" be request of client
            //titleLabel.text = "Not selected yet"
        }
        layoutTitle()
        layoutSubviews()
    }
    
    func setServiceInfo(service: Service, targetUser: TargetUser? = nil) {
        iconImageView.image = UIImage.init(named: service.imageName)
        let titleString = NSMutableAttributedString(
            string: service.title,
            attributes: [NSFontAttributeName:UIFont(
                name: "SFUIText-Regular",
                size: 16.0)!])
        titleString.addAttribute(
            NSForegroundColorAttributeName,
            value: UIColor.init(hex: "#333333"),
            range: NSRange(
                location:0,
                length:titleString.length))
        if let _ = targetUser {
            let additionalString = NSMutableAttributedString(
                string: "For " + targetUser!.title.lowercased(),
                attributes: [NSFontAttributeName:UIFont(
                    name: "SFUIText-Regular",
                    size: 14.0)!])
            additionalString.addAttribute(
                NSForegroundColorAttributeName,
                value: UIColor.init(hex: "#8A9093"),
                range: NSRange(
                    location:0,
                    length:additionalString.length))
            titleString.append(NSAttributedString.init(string: "\n"))
            titleString.append(additionalString)
        }
        titleLabel.attributedText = titleString
    }
    
    func setProductsInfo(service: Service, category: BusinessCategory) {
        iconImageView.image = UIImage.init(named: service.imageName)
        let titleString = category.title + ", " + service.title
        titleLabel.text = titleString
    }
    
    func setDetailsInfo(request: Request) {
        iconImageView.image = UIImage.init(named: "icon_details")
        let titleString = request.productItem! + ", " + request.productBrand!
        let priceString = String(request.minPrice!) + "-" + String(request.maxPrice!) + " chf"
        let titleAttributedString = NSMutableAttributedString(
            string: titleString,
            attributes: [NSFontAttributeName:UIFont(
                name: "SFUIText-Regular",
                size: 16.0)!])
        titleAttributedString.addAttribute(
            NSForegroundColorAttributeName,
            value: UIColor.init(hex: "#333333"),
            range: NSRange(
                location:0,
                length:titleAttributedString.length))
        let additionalString = NSMutableAttributedString(
            string: priceString,
            attributes: [NSFontAttributeName:UIFont(
                name: "SFUIText-Regular",
                size: 14.0)!])
        additionalString.addAttribute(
            NSForegroundColorAttributeName,
            value: UIColor.init(hex: "#8A9093"),
            range: NSRange(
                location:0,
                length:additionalString.length))
        titleAttributedString.append(NSAttributedString.init(string: "\n"))
        titleAttributedString.append(additionalString)
        titleLabel.attributedText = titleAttributedString
    }
    
    func setLocationInfo(location: RequestLocation) {
        iconImageView.image = UIImage.init(named: location.iconName)
        var locationString: String!
        switch location {
        case .myPlace( _, _):
            locationString = location.address
        case .atTheSalon( _, let distance):
            locationString = location.address+" + \(String.init(format: "%.2f", distance))km"
        }
        let titleString = NSMutableAttributedString(
            string: locationString,
            attributes: [NSFontAttributeName:UIFont(
                name: "SFUIText-Regular",
                size: 16.0)!])
        titleString.addAttribute(
            NSForegroundColorAttributeName,
            value: UIColor.init(hex: "#333333"),
            range: NSRange(
                location:0,
                length:titleString.length))
        //        if let _ = targetUser {
        let additionalString = NSMutableAttributedString(
            string: location.description,
            attributes: [NSFontAttributeName:UIFont(
                name: "SFUIText-Regular",
                size: 14.0)!])
        additionalString.addAttribute(
            NSForegroundColorAttributeName,
            value: UIColor.init(hex: "#8A9093"),
            range: NSRange(
                location:0,
                length:additionalString.length))
        titleString.append(NSAttributedString.init(string: "\n"))
        titleString.append(additionalString)
        //        }
        titleLabel.attributedText = titleString
    }
    
    func setData(imageName: String, title: String) {
        titleLabel.text = title
        iconImageView.image = UIImage.init(named: imageName)
    }
}
