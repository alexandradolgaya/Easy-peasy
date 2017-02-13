//
//  RequestProductDetailsVC.swift
//  pingget
//
//  Created by Victor on 30.12.16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit
import MARKRangeSlider

class RequestProductDetailsVC: NavBarVC {
    
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var backView: ViewShadow!
    @IBOutlet weak var itemField: TextFieldBottomLine!
    @IBOutlet weak var brandField: TextFieldBottomLine!
    var priceRangeSlider: MARKRangeSlider!
    
    var request: Request?
    static let id = "RequestProductDetailsVC"

    override func viewDidLoad() {
        super.viewDidLoad()
        backView.layer.cornerRadius = 4.0
        initSlider()
        updateUI()
        textFieldsToHideKeyboard = [itemField, brandField]
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    private func updateUI() {
        if let item = request?.productItem {
            itemField.text = item
        }
        if let brand = request?.productBrand {
            brandField.text = brand
        }
        if let min = request?.minPrice, let max = request?.maxPrice{
            priceRangeSlider.setLeftValue(CGFloat(min), rightValue: CGFloat(max))
        }
    }
    
    private func initSlider() {
        priceRangeSlider = MARKRangeSlider.init(frame: CGRect.init(x: 55, y: 8, width: UIScreen.main.bounds.width - 60 - 120, height: 20))
        priceRangeSlider.addTarget(self, action: #selector(sliderValueDidChange), for: .valueChanged)
        
        priceRangeSlider.setMinValue(10, maxValue: 500)
        priceRangeSlider.minimumDistance = 1.0
        priceView.addSubview(priceRangeSlider)
    }
    
    func sliderValueDidChange(slider: MARKRangeSlider) {
        print(slider.leftValue)
    }
    
    private func dataFilled() -> Bool {
        var isFilled = true
        if itemField.text == "" {
            isFilled = false
            if let _ = itemField.errorLabel {
                itemField.displayError()
            }
        }
        if brandField.text == "" {
            isFilled = false
            if let _ = brandField.errorLabel {
                brandField.displayError()
            }
        }
        return isFilled
    }
    
    
    private func updateRequest() {
        request?.productItem = itemField.text
        request?.productBrand = brandField.text
        request?.minPrice = Int(priceRangeSlider.leftValue)
        request?.maxPrice = Int(priceRangeSlider.rightValue)
    }
    
    @IBAction func nextTapped(_ sender: AnyObject) {
        if dataFilled() == true {
            updateRequest()
            performSegue(withIdentifier: "ShowFromWhereSegue", sender: sender)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMapSegue" {
            guard let mapVC = segue.destination as? RequestMapVC else { return }
            mapVC.isService = false
        }
        else {
        guard let requestHolder = segue.destination as? RequestHolder else { return }
        requestHolder.setRequestData(request: request, doneButtonDelegate: nil)
        }
    }
}

extension RequestProductDetailsVC: RequestHolder {
    func setRequestData(request: Request?, doneButtonDelegate: RequestDoneButtonDelegate?) {
        self.request = request
//        self.doneButtonDelegate = doneButtonDelegate
    }
}
