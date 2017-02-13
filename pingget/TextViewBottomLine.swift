//
//  TextViewBottomLine.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/21/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit
import Foundation

class TextViewBottomLine: UITextView {
    override func draw(_ rect: CGRect) {
        UIView.drawBottomLine(rect: rect)
    }
    
    let placeholderLabel: UILabel = {
        var label  = UILabel()
        return label
    }()
    
    override func awakeFromNib() {
        addSubview(placeholderLabel)
        placeholderLabel.attributedText = NSAttributedString.init(string: "Your comment",
                                                                  attributes: [NSForegroundColorAttributeName : UIColor.gray,
                                                                               NSFontAttributeName: UIFont.systemFont(ofSize: 14.0)])
        placeholderLabel.frame = UIEdgeInsetsInsetRect(CGRect(x:placeholderLabel.frame.origin.x,
                                                              y:placeholderLabel.frame.origin.y+7.0,
                                                              width:placeholderLabel.frame.size.width + 5.0,
                                                              height:placeholderLabel.frame.size.height + 5.0), UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0))
        placeholderLabel.sizeToFit()
        showPlaceholderIfNeeded()
    }
    
    func showPlaceholderIfNeeded() -> Void {
        placeholderLabel.isHidden = text != ""
    }
}
