//
//  BaseVC.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/11/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
    
    var scrollViewForKeyboard: UIScrollView?
    var textFieldsToHideKeyboard: [UITextField]? {
        didSet {
            textFieldsToHideKeyboard?.forEach({ $0.delegate = self })
        }
    }
    
    var animationDuration: Double { return 0.3 }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewTapGestureRecognizer()
        initKeyboardNotifications()
    }
    
    private func addViewTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tapGestureRecognizer.cancelsTouchesInView = false
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func layoutView() {
        view.layoutIfNeeded()
    }
    
    func viewTapped() {
        hideKeyboard()
    }
    
    private func initKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        guard let scrollViewForKeyboard = scrollViewForKeyboard else { return }
        
        let keyboardFrame = getKeyboardFrame(notification: notification)
        
        var contentInset = scrollViewForKeyboard.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollViewForKeyboard.contentInset = contentInset
    }
    
    func getKeyboardFrame(notification: NSNotification) -> CGRect {
        var userInfo = notification.userInfo!
        let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        return view.convert(keyboardFrame, from: nil)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        guard let scrollViewForKeyboard = scrollViewForKeyboard else { return }
        
        let contentInset = UIEdgeInsets.zero
        scrollViewForKeyboard.contentInset = contentInset
    }
    
    static func createVC(storyboard: Storyboard, vcId: String) -> UIViewController? {
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: vcId)
    }
}

enum Storyboard: String {
    case signUp = "SignUp"
    case user = "User"
}

extension BaseVC: UITextFieldDelegate {
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}

extension BaseVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !(touch.view is UIControl)
    }
}
