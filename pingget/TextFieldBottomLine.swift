//
//  TextFieldBottomLine.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/14/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class TextFieldBottomLine: UITextField {
    
    var leftOffsetView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    var rightOffsetView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    @IBOutlet weak var errorLabel : UILabel!
    
    @IBInspectable
    var leftOffset: CGFloat = 0 {
        didSet {
            leftOffsetView.frame.size.width = leftOffset
        }
    }
    
    @IBInspectable
    var rightOffset: CGFloat = 0 {
        didSet {
            rightOffsetView.frame.size.width = rightOffset
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        addPaddings()
    }
    
    func displayError(text: String? = nil) {
        if let _ = text {
            errorLabel.text = text
        }
        errorLabel.isHidden = false
    }
    
    func hideError() {
        errorLabel.isHidden = true
    }
    
    func textFieldDidChange(_ sender: UITextField) {
        if errorLabel != nil && errorLabel.isHidden == false {
            errorLabel.isHidden = true
        }
    }
    
    private func addPaddings() {
        leftView = leftOffsetView
        leftViewMode = UITextFieldViewMode.always
        
        rightView = rightOffsetView
        rightViewMode = UITextFieldViewMode.always
    }
    
    override func draw(_ rect: CGRect) {
        UIView.drawBottomLine(rect: rect)
    }
}
