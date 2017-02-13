//
//  LoginVC.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/14/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class LoginVC: NavBarVC {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginView : ViewShadow!
    @IBOutlet weak var emailField: TextFieldBottomLine!
    @IBOutlet weak var passwordField: TextFieldBottomLine!
    @IBOutlet weak var phoneField: TextFieldBottomLine?
    @IBOutlet weak var scrollViewContentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollViewContentView: UIView!
    
    static let id = "LoginVC"
    static let showUserSegue = "ShowUserSegue"
    static let showSupplierSeque = "ShowSupplierSeque"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewsForKeyboard()
        loginView.layer.cornerRadius = 4.0
        if var tx = textFieldsToHideKeyboard {
            tx = [emailField,passwordField]
        }
        if let ph = phoneField {
            textFieldsToHideKeyboard?.append(ph)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        switch screenHeight {
        case iPhone5:
            guard scrollViewContentViewHeight != nil else {
                break
            }
            adjustScreen()
        default:
            break
        }
    }
    
    private func adjustScreen() {
        let newConstraint = NSLayoutConstraint.init(item: scrollViewContentViewHeight.firstItem, attribute: scrollViewContentViewHeight.firstAttribute, relatedBy: scrollViewContentViewHeight.relation, toItem: scrollViewContentViewHeight.secondItem, attribute: scrollViewContentViewHeight.secondAttribute, multiplier: 1.174, constant: scrollViewContentViewHeight.constant)
        self.scrollView.removeConstraint(scrollViewContentViewHeight)
        self.scrollView.addConstraint(newConstraint)
        scrollViewContentViewHeight = newConstraint
    }
    
    private func setViewsForKeyboard() {
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
    
    @IBAction func signupViaFB(_ sender: AnyObject) {
        UserDefaults.standard.set(true, forKey: "Authorized")
    }
    
    @IBAction func signupViaGoogle(_ sender: AnyObject) {
        UserDefaults.standard.set(true, forKey: "Authorized")
    }
    
    @IBAction func loginViaFB(_ sender: AnyObject) {
        UserDefaults.standard.set(true, forKey: "Authorized")
        /* Temporary > to fix Create Request Details segue */
        UserDefaults.standard.set("user", forKey: "user_type")
        openUser()
    }
    
    @IBAction func loginViaGoogle(_ sender: AnyObject) {
        UserDefaults.standard.set(true, forKey: "Authorized")
        /* Temporary > to fix Create Request Details segue */
        UserDefaults.standard.set("user", forKey: "user_type")
        openUser()
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

    private func openUser() {
        performSegue(withIdentifier: LoginVC.showUserSegue, sender: self)
    }
    
    private func openSupplier() {
        performSegue(withIdentifier: LoginVC.showSupplierSeque, sender: self)
    }
    
}
