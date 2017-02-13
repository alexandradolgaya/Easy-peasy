//
//  SupplierSignUpVC.swift
//  pingget
//
//  Created by Victor on 23.12.16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class SupplierSignUpVC: LoginVC {
    
    static let showSetupSegue = "ShowSetupSegue"

    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldsToHideKeyboard = [emailField,passwordField]
        if let ph = phoneField {
            textFieldsToHideKeyboard?.append(ph)
        }
    }

    @IBAction override func login(_ sender: AnyObject) {
        if dataIsFilled() == true {
            performSegue(withIdentifier: SupplierSignUpVC.showSetupSegue, sender: sender)
        }
    }
    
    private func dataIsFilled() -> Bool {
        var isFilled = true
        if emailField.text == "" {
            isFilled = false
            if let _ = emailField.errorLabel {
                emailField.displayError()
            }
        }
        if passwordField.text == "" {
            isFilled = false
            if let _ = passwordField.errorLabel {
                passwordField.displayError()
            }
        }
        if phoneField != nil && phoneField!.text == "" {
            isFilled = false
            if let _ = phoneField!.errorLabel {
                phoneField!.displayError()
            }
        }
        return isFilled
    }
    
}
