//
//  RequestDetailsVC.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/29/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class RequestDetailsVC: NavBarVC {
    @IBOutlet weak var serviceTypeImageView: UIImageView!
    @IBOutlet weak var targetUserImageView: UIImageView!
    @IBOutlet weak var servicesNameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var datesLabel: UILabel!
    @IBOutlet weak var backView: ViewShadow!
    
    
    static let id = "RequestDetailsVC"
    private var request: Request?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.layer.cornerRadius = 4.0
        updateUI()
    }
    
    func setData(request: Request?) {
        self.request = request
    }
    
    @IBAction func showOptions(_ sender: Any) {
        OptionsPopup.show(fromVC: self, request: request, type: OptionsPopupType.myRequestDetails, delegate: self)
    }
    
    @IBAction func respondButtonPressed(_ sender: Any) {
        let chatView = ChatViewController()
        chatView.messages = makeNormalConversation()
        let chatNavigationController = UINavigationController(rootViewController: chatView)
        self.navigationController?.pushViewController(chatView, animated: false)
    }
    
    private func updateUI() {
//        let icon = request?.forWho.first?.title == "Female" ? "icon_female_small" : "icon_male_small"
        serviceTypeImageView.image = UIImage.init(named: (request?.services.first?.imageName)!)
        targetUserImageView.image = UIImage.init(named: "icon_" + (request?.forWho.first?.title.lowercased())! + "_small")
        servicesNameLabel.text = request?.servicesFormatted
        commentLabel.text = request?.comment
        guard let dt = request?.date else {
            datesLabel.text = "Unknown date"
            return
        }
        if dt.startDateAndTimeFormatted == dt.endDateAndTimeFormatted {
            datesLabel.text = dt.startDateAndTimeFormatted
        } else {
            datesLabel.text = "\(dt.startDateFormatted) - \(dt.endDateFormatted), \(dt.timeRange)"
        }
        guard let requestLocation = request?.location else { return }
        var locationString: String!
        switch requestLocation {
        case .myPlace( _, _):
            locationString = requestLocation.address
        case .atTheSalon( _, let distance):
             
            locationString = "At the salon"
        }
        let titleString = NSMutableAttributedString(
            string: locationString,
            attributes: [NSFontAttributeName:UIFont(
                name: "SFUIText-Regular",
                size: 14.0)!])
        titleString.addAttribute(
            NSForegroundColorAttributeName,
            value: UIColor.init(hex: "#333333"),
            range: NSRange(
                location:0,
                length:titleString.length))
        
//        if request?.location?.description == "At the salon" {
//            let additionalString = NSMutableAttributedString(
//                string: (request?.location?.description)!,
//                attributes: [NSFontAttributeName:UIFont(
//                    name: "SFUIText-Regular",
//                    size: 14.0)!])
//            additionalString.addAttribute(
//                NSForegroundColorAttributeName,
//                value: UIColor.init(hex: "#8A9093"),
//                range: NSRange(
//                    location:0,
//                    length:additionalString.length))
//            additionalString.append(NSAttributedString.init(string: "\n"))
//            additionalString.append(titleString)
//            locationLabel.attributedText = additionalString
//        } else {
            locationLabel.attributedText = titleString
//        }
    }
}

extension RequestDetailsVC: OptionsPopupDelegate {
    func optionSelected(option: Int, cell: Int) {
        
    }
}
