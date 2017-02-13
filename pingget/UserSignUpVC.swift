//
//  UserSignUpVC.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/25/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class UserSignUpVC: NavBarVC {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backView: ViewShadow!
    @IBOutlet weak var emailField: TextFieldBottomLine!
    @IBOutlet weak var passwordField: TextFieldBottomLine!
    
    static let showUserSegue = "ShowUserSignupSegue"
    static let showSupplierSeque = "ShowSupplierSignupSeque"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.layer.cornerRadius = 4.0
        textFieldsToHideKeyboard = [emailField, passwordField]
    }
    
    private func initViewsForKeyboard() {
        scrollViewForKeyboard = scrollView
    }
    
    @IBAction func login(_ sender: AnyObject) {
        if dataIsFilled() == true {
            UserDefaults.standard.set(true, forKey: "Authorized")
            if emailField.text == "business@mail.com" {
                UserDefaults.standard.set("supplier", forKey: "user_type")
                openSupplier()
            }
            else {
                UserDefaults.standard.set("user", forKey: "user_type")
                openUser()
            }
            UserDefaults.standard.set(emailField.text, forKey: "user_email")
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
        return isFilled
    }
    
    private func openUser() {
        performSegue(withIdentifier: UserSignUpVC.showUserSegue, sender: self)
    }
    
    private func openSupplier() {
        performSegue(withIdentifier: UserSignUpVC.showSupplierSeque, sender: self)
    }
}
