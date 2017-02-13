//
//  DetailedRequestInfoPopup.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/25/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

protocol DetailedRequestInfoPopupDelegate: class {
    func markCompletedTapped(popup: BasePopupVC, type: SupplierPopupType)
}

enum ViewDetailsTag: Int {
    case Booked = 1
    case Completed
}

class DetailedRequestInfoPopup: BasePopupVC {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var servicesNameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var datesLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var popupView: ViewShadow!
    @IBOutlet weak var markBookedButton: RoundedBorderButton!
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    
    static let id = "DetailedRequestInfoPopup"
    
    private var request: Request?
    private weak var delegate: DetailedRequestInfoPopupDelegate?
    
    static func show(fromVC: UIViewController, request: Request?, delegate: DetailedRequestInfoPopupDelegate?) {
        let popup = create(popupId: id) as! DetailedRequestInfoPopup
        popup.setData(request: request, delegate: delegate)
        popup.show(fromVC: fromVC)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius = 4
        updateUI()
        switch screenHeight {
        case iPhone5:
            topLayoutConstraint.constant = 10.0
            self.view.layoutIfNeeded()
        default:
            break
        }
    }
    
    func setData(request: Request?, delegate: DetailedRequestInfoPopupDelegate?) {
        self.request = request
        self.delegate = delegate
    }
    
    private func updateUI() {
        iconImageView.image = UIImage.init(named: (request?.services.first?.imageName)!)
        servicesNameLabel.text = request?.servicesFormatted
        commentLabel.text = request?.comment
//        locationLabel.text = request?.location?.description
        setAddress()
        datesLabel.text = request?.date?.startDateAndTimeFormatted
        if let rq = self.request {
            guard rq.simulationResponser.count > 0 else {
                markBookedButton.isEnabled = false
                markBookedButton.alpha = 0.5
                return
            }
        }
    }
    
    private func setAddress() {
        
        let titleString = NSMutableAttributedString(
            string: (request?.location?.address)!,
            attributes: [NSFontAttributeName:UIFont(
                name: "SFUIText-Regular",
                size: 16.0)!])
        titleString.addAttribute(
            NSForegroundColorAttributeName,
            value: UIColor.init(hex: "#333333"),
            range: NSRange(
                location:0,
                length:titleString.length))

        if request?.location?.description == "At the salon" {
            let additionalString = NSMutableAttributedString(
                string: (request?.location?.description)!,
                attributes: [NSFontAttributeName:UIFont(
                    name: "SFUIText-Regular",
                    size: 14.0)!])
            additionalString.addAttribute(
                NSForegroundColorAttributeName,
                value: UIColor.init(hex: "#8A9093"),
                range: NSRange(
                    location:0,
                    length:additionalString.length))
            additionalString.append(NSAttributedString.init(string: "\n"))
            additionalString.append(titleString)
            locationLabel.attributedText = additionalString
        }
        else {
            locationLabel.attributedText = titleString
        }
    }
    
    @IBAction func markCompletedTapped(_ sender: UIButton) {
        delegate?.markCompletedTapped(popup: self, type: SupplierPopupType(rawValue: sender.tag)!)
    }
}
