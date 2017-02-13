//
//  RequestFromWhereVC.swift
//  pingget
//
//  Created by Victor on 03.01.17.
//  Copyright © 2017 Steelkiwi. All rights reserved.
//

import UIKit

class RequestFromWhereVC: NavBarVC {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backView: ViewShadow!
    
    @IBOutlet weak var salonLocationView: BottomDashedView!
    private var salonLocationHeight: CGFloat = 0
    @IBOutlet weak var salonLocationHeightConstraint: NSLayoutConstraint! {
        didSet {
            salonLocationHeight = salonLocationHeightConstraint.constant
        }
    }
    @IBOutlet weak var salonLocationTitleView: UIView!
    @IBOutlet weak var salonLocationDetailsView: UIView!
    @IBOutlet var salonLocationTapRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var salonAddressTextField: TextFieldBottomLine!
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var atSalonCheckbox: UIImageView!
    
    // Map hint
    @IBOutlet weak var salonLocationHintView: DashedView!
    private var salonLocationHintHeight: CGFloat = 0
    @IBOutlet weak var salonLocationHintHeightConstraint: NSLayoutConstraint! {
        didSet {
            salonLocationHintHeight = salonLocationHintHeightConstraint.constant
        }
    }
    
    var request: Request?
    var doneButtonDelegate: RequestDoneButtonDelegate?
    
    static let id = "RequestFromWhereVC"

    override func viewDidLoad() {
        super.viewDidLoad()
        backView.layer.cornerRadius = 4.0
        salonLocationHintView.layer.cornerRadius = 4.0
        setViewsForKeyboard()
        createLeftView(to: salonAddressTextField)
        updateUI()
        textFieldsToHideKeyboard = [salonAddressTextField]
//        updateLocationViews()
    }
    
    private func createLeftView(to field: UITextField) {
        //        let leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 30.0, height: 30.0))
        let leftImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 30.0, height: 20.0))
        leftImageView.contentMode = .scaleAspectFit
        leftImageView.image = UIImage.init(named: "icon_location")
        field.leftView = leftImageView
        field.leftViewMode = .always
        leftImageView.center = CGPoint.init(x: 15, y: field.bounds.size.height / 2)
    }
    
    private func updateUI() {
        guard let requestLocation = request?.location else { return }
        switch requestLocation {
        case .atTheSalon(let address, let distance):
            salonAddressTextField.text = address
            distanceSlider.value = distance
        default: break
        }
    }
    
    private func setViewsForKeyboard() {
        scrollViewForKeyboard = scrollView
    }
    
    private func hideSalonLocationHint() {
        salonLocationHeightConstraint.constant -= salonLocationHintHeight
        salonLocationHintHeightConstraint.constant = 0
        salonLocationHintView.isHidden = true
    }
    
    private func createSalonLocation() -> RequestLocation {
        return .atTheSalon(address: salonAddressTextField.text, distance: distanceSlider.value)
    }
    
    private func updateSalonLocation(location: RequestLocation) {
        request?.location = location
//        updateLocationViews()
    }
    
    private func updateRequest() {
//        guard let requestLocation = request?.location else { return }
//        switch requestLocation {
//        case .myPlace:
//            request?.location = createMyPlaceLocation()
//        case .atTheSalon:
            request?.location = createSalonLocation()
//        default: break
//        }
    }
    
    @IBAction func salonLocationTapped(_ sender: AnyObject) {
        updateSalonLocation(location: createSalonLocation())
    }
    
    @IBAction func salonLocationHintTapped(_ sender: AnyObject) {
        hideSalonLocationHint()
    }
    
    @IBAction func nextTapped(_ sender: AnyObject) {
        if salonAddressTextField.text != "" {            
            updateRequest()
            if let doneButtonDelegate = doneButtonDelegate, let request = request { doneButtonDelegate.doneTapped(request: request) }
            else { performSegue(withIdentifier: RequestProductDateVC.id, sender: nil) }
        } else {
            if let _ = salonAddressTextField.errorLabel {
                salonAddressTextField.displayError()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let requestHolder = segue.destination as? RequestHolder else { return }
        requestHolder.setRequestData(request: request, doneButtonDelegate: nil)
    }
    
    @IBAction func unwindFromMapVC(segue: UIStoryboardSegue) {
        guard let requestMapLocation = segue.source as? RequestMapLocation else { return }
        salonAddressTextField.text = requestMapLocation.address
        distanceSlider.value = requestMapLocation.distance
    }
}

extension RequestFromWhereVC: RequestHolder {
    func setRequestData(request: Request?, doneButtonDelegate: RequestDoneButtonDelegate?) {
        self.request = request
        self.doneButtonDelegate = doneButtonDelegate
    }
}
