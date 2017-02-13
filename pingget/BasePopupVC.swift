//
//  BasePopupVC.swift
//  MathWithYourFriends
//
//  Created by Igor Prysyazhnyuk on 9/21/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

class BasePopupVC: BaseVC {

    private weak var popupContentView: UIView?
    
    override var animationDuration: Double { return 0.3 }
    private let transparentViewTag = 2
    var shouldCloseOnOutsideTap = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        addTransparentViewTapGestureRecognizer()
    }
    
    private func addTransparentViewTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(transparentViewTapped))
        let transparentView = view.subviews.filter({ $0.tag == transparentViewTag }).first
        transparentView?.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func transparentViewTapped() {
        if shouldCloseOnOutsideTap { close() }
    }
    
    private func initViews() {
        view.backgroundColor = UIColor.clear
        view.isHidden = true
        view.alpha = 0
        
        let popupViewTag = 1
        popupContentView = view.subviews.filter({ $0.tag == popupViewTag }).first
        let cancelButtonTag = 1
        let cancelButton = popupContentView?.subviews.filter({ $0.tag == cancelButtonTag }).first as? UIButton
        cancelButton?.addTarget(self, action: #selector(cancelTapped), for: UIControlEvents.touchUpInside)
    }
    
    func fadeIn() {
        view.isHidden = false
        let viewScale: CGFloat = 1.15
        UIView.animate(withDuration: animationDuration) {
            self.view.alpha = 1
        }
        
        let scaleAnimationDuration = 0.25
        
        popupContentView?.transform = CGAffineTransform(scaleX: viewScale, y: viewScale)
        UIView.animate(withDuration: scaleAnimationDuration) {
            self.popupContentView?.transform = CGAffineTransform.identity
        }
    }
    
    func fadeOut(finished: @escaping () -> ()) {
        UIView.animate(withDuration: animationDuration, animations: {
            self.view.alpha = 0
        }) { (done) in
            finished()
        }
    }
    
    static func create(popupId: String, shouldCloseOnOutsideTap: Bool = true) -> BasePopupVC {
        let basePopup = UIStoryboard(name: "Popups", bundle: nil).instantiateViewController(withIdentifier: popupId) as! BasePopupVC
        basePopup.shouldCloseOnOutsideTap = shouldCloseOnOutsideTap
        return basePopup
    }
    
    func show(fromVC: UIViewController, popupPresented: (() -> ())? = nil) {
        modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        fromVC.present(self, animated: false) {
            popupPresented?()
            self.fadeIn()
        }
    }
    
    func close(completed: (() -> ())? = nil) {
        fadeOut(finished: {
            self.dismiss(animated: false, completion: { 
                completed?()
            })
        })
    }
    
    @IBAction func cancelTapped(_ sender: AnyObject) {
        close()
    }
}
