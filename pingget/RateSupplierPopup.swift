//
//  RateSupplierPopup.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/28/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

protocol RateSupplierPopupDelegate: class {
    func rateSupplierTapped(rating: Int, comment: String?)
}

class RateSupplierPopup: BasePopupVC {
    @IBOutlet weak var commentTextView: TextViewBottomLine!
    @IBOutlet weak var popupView: ViewShadow!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var firstStarButton: UIButton!
    @IBOutlet weak var secondStarButton: UIButton!
    @IBOutlet weak var thirdStarButton: UIButton!
    @IBOutlet weak var fourthStarButton: UIButton!
    @IBOutlet weak var fifthStarButton: UIButton!
    
    static let id = "RateSupplierPopup"
    weak var delegate: RateSupplierPopupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius = 4.0
    }
    
    static func show(fromVC: UIViewController, delegate: RateSupplierPopupDelegate?) {
        let popup = create(popupId: id) as! RateSupplierPopup
        popup.setData(delegate: delegate)
        popup.show(fromVC: fromVC)
    }
    
    private func setData(delegate: RateSupplierPopupDelegate?) {
        self.delegate = delegate
    }
    
    @IBAction func setRating(_ sender: UIButton) {
        
        //        for index in 1...5 {
        //            guard let rateButton = backView.viewWithTag(index) as? UIButton else {return}
        //            rateButton.setBackgroundImage(UIImage.init(named: "icon_star_empty"), for: .normal)
        //        }
        //        for index in 1...sender.tag {
        //            guard let rateButton = backView.viewWithTag(index) as? UIButton else {return}
        //            rateButton.setBackgroundImage(UIImage.init(named: "icon_star_filled"), for: .normal)
        //        }
        firstStarButton.setBackgroundImage(UIImage.init(named: "icon_star_empty"), for: .normal)
        
        secondStarButton.setBackgroundImage(UIImage.init(named: "icon_star_empty"), for: .normal)
        
        thirdStarButton.setBackgroundImage(UIImage.init(named: "icon_star_empty"), for: .normal)
        
        fourthStarButton.setBackgroundImage(UIImage.init(named: "icon_star_empty"), for: .normal)
        
        fifthStarButton.setBackgroundImage(UIImage.init(named: "icon_star_empty"), for: .normal)
        if sender.tag > 0 {
            firstStarButton.setBackgroundImage(UIImage.init(named: "icon_star_filled"), for: .normal)
        }
        if sender.tag > 1 {
            secondStarButton.setBackgroundImage(UIImage.init(named: "icon_star_filled"), for: .normal)
        }
        if sender.tag > 2 {
            thirdStarButton.setBackgroundImage(UIImage.init(named: "icon_star_filled"), for: .normal)
        }
        if sender.tag > 3 {
            fourthStarButton.setBackgroundImage(UIImage.init(named: "icon_star_filled"), for: .normal)
        }
        if sender.tag > 4 {
            fifthStarButton.setBackgroundImage(UIImage.init(named: "icon_star_filled"), for: .normal)
        }
    }
    
    @IBAction func rateSupplierTapped(_ sender: AnyObject) {
        close {
            self.delegate?.rateSupplierTapped(rating: 0, comment: self.commentTextView.text)
        }
    }
}

extension RateSupplierPopup: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView is TextViewBottomLine else {
            return
        }
        (textView as! TextViewBottomLine).placeholderLabel.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard textView is TextViewBottomLine else {
            return
        }
        (textView as! TextViewBottomLine).showPlaceholderIfNeeded()
    }
}
