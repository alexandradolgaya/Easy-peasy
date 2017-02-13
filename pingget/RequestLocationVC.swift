//
//  RequestLocationVC.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/16/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit

protocol RequestMapLocation {
    var address: String? { get }
    var distance: Float { get }
}

class RequestLocationVC: NavBarVC {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backView: ViewShadow!
    
    // My place location
    @IBOutlet weak var myPlaceLocationView: BottomDashedView!
    @IBOutlet weak var myPlaceTitleView: UIView!
    private var locationTitleViewHeight: CGFloat = 0
    @IBOutlet weak var locationTitleViewHeightConstraint: NSLayoutConstraint! {
        didSet {
            locationTitleViewHeight = locationTitleViewHeightConstraint.constant
        }
    }
    private var myPlaceLocationHeight: CGFloat = 0
    @IBOutlet weak var myPlaceHeightConstraint: NSLayoutConstraint! {
        didSet {
            myPlaceLocationHeight = myPlaceHeightConstraint.constant
        }
    }
    @IBOutlet weak var myPlaceDetailsView: UIView!
    @IBOutlet var myPlaceLocationTapRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var myPlaceAddressTextField: TextFieldBottomLine!
    @IBOutlet weak var atPlaceCheckbox: UIImageView!
    @IBOutlet weak var dontShowAddressCheckbox: UIImageView!
    
    // Salon location
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
    private var locationManager: CLLocationManager!

    var request: Request?
    var doneButtonDelegate: RequestDoneButtonDelegate?
    static let id = "RequestLocationVC"
    var notShowAddress: Bool! = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.layer.cornerRadius = 4.0
        salonLocationHintView.layer.cornerRadius = 4.0
        setViewsForKeyboard()
        createLeftView(to: myPlaceAddressTextField)
        createLeftView(to: salonAddressTextField)
        updateUI()
        updateLocationViews()
        textFieldsToHideKeyboard = [myPlaceAddressTextField, salonAddressTextField]
//        setDashed(view: salonLocationHintView)
    }
    
    private func updateLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    private func createLeftView(to field: UITextField) {
//        let leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 30.0, height: 30.0))
        let leftImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 30.0, height: 20.0))
        leftImageView.contentMode = .scaleAspectFit
        leftImageView.image = UIImage.init(named: "icon_location")
        field.leftView = leftImageView
        field.leftViewMode = .always
        leftImageView.center = CGPoint.init(x: 15, y: myPlaceAddressTextField.bounds.size.height / 2)
    }
    
    private func updateUI() {
        guard let requestLocation = request?.location else { return }
        switch requestLocation {
        case .myPlace(let address, let dontShowAddress):
            myPlaceAddressTextField.text = address
        case .atTheSalon(let address, let distance):
            salonAddressTextField.text = address
            distanceSlider.value = distance
        }
    }
    
    private func setDashed(view: UIView) {
        var border = CAShapeLayer.init()
        border.strokeColor = UIColor.init(redInt: 39, greenInt: 156, blueInt: 229).cgColor
        border.lineDashPattern = [4, 2]
        border.path = UIBezierPath.init(rect: view.bounds).cgPath
        border.frame = view.bounds
        view.layer.addSublayer(border)
    }
    
    private func updateLocationViews() {
        guard let requestLocation = request?.location, scrollView != nil else {
            hideLocationsDetails()
            return
        }
        switch requestLocation {
        case .myPlace: openMyPlaceLocationView()
        case .atTheSalon: openSalonLocationView()
        }
    }
    
    private func setViewsForKeyboard() {
        scrollViewForKeyboard = scrollView
    }
    
    private func openMyPlaceLocationView() {
        myPlaceDetailsView.isHidden = false
        myPlaceHeightConstraint.constant = myPlaceLocationHeight
        salonLocationDetailsView.isHidden = true
        salonLocationHeightConstraint.constant = locationTitleViewHeight
        myPlaceLocationTapRecognizer.isEnabled = false
        salonLocationTapRecognizer.isEnabled = true
        atPlaceCheckbox.image = UIImage.init(named: "icon_selected")
        atSalonCheckbox.image = UIImage.init(named: "icon_not_selected")
    }
    
    private func openSalonLocationView() {
        myPlaceDetailsView.isHidden = true
        myPlaceHeightConstraint.constant = locationTitleViewHeight
        salonLocationDetailsView.isHidden = false
        salonLocationHeightConstraint.constant = salonLocationHeight
        myPlaceLocationTapRecognizer.isEnabled = true
        salonLocationTapRecognizer.isEnabled = false
        atSalonCheckbox.image = UIImage.init(named: "icon_selected")
        atPlaceCheckbox.image = UIImage.init(named: "icon_not_selected")
        showSalonLocationHint()
    }
    
    private func hideLocationsDetails() {
        myPlaceDetailsView.isHidden = true
        salonLocationDetailsView.isHidden = true
        myPlaceHeightConstraint.constant = locationTitleViewHeight
        salonLocationHeightConstraint.constant = locationTitleViewHeight
    }
    
    private func showSalonLocationHint() {
        salonLocationHintHeightConstraint.constant = salonLocationHintHeight
        salonLocationHintView.isHidden = false
    }
    
    private func hideSalonLocationHint() {
        salonLocationHeightConstraint.constant -= salonLocationHintHeight
        salonLocationHintHeightConstraint.constant = 0
        salonLocationHintView.isHidden = true
    }
    
    private func createMyPlaceLocation() -> RequestLocation {
        return .myPlace(address: myPlaceAddressTextField.text, dontShowAddress: notShowAddress)
    }
    
    private func createSalonLocation() -> RequestLocation {
        return .atTheSalon(address: salonAddressTextField.text, distance: distanceSlider.value)
    }
    
    private func updateSalonLocation(location: RequestLocation) {
        request?.location = location
        updateLocationViews()
    }
    
    private func updateRequest() {
        guard let requestLocation = request?.location else { return }
        switch requestLocation {
        case .myPlace:
            request?.location = createMyPlaceLocation()
        case .atTheSalon:
            request?.location = createSalonLocation()
        }
    }
    
    @IBAction func showAddress(_ sender: AnyObject) {
        notShowAddress = !notShowAddress
        dontShowAddressCheckbox.image = notShowAddress == true ? UIImage.init(named: "icon_selected") : UIImage.init(named: "icon_not_selected")
    }
    
    @IBAction func myPlaceTapped(_ sender: AnyObject) {
        updateLocation()
        updateSalonLocation(location: createMyPlaceLocation())
    }
    
    @IBAction func salonLocationTapped(_ sender: AnyObject) {
        
        updateSalonLocation(location: createSalonLocation())
    }
    
    @IBAction func salonLocationHintTapped(_ sender: AnyObject) {
        hideSalonLocationHint()
    }
    
    @IBAction func unwindFromMapVC(segue: UIStoryboardSegue) {
        guard let requestMapLocation = segue.source as? RequestMapLocation else { return }
        salonAddressTextField.text = requestMapLocation.address
        distanceSlider.value = requestMapLocation.distance
    }
    
    @IBAction func nextTapped(_ sender: AnyObject) {
        updateRequest()
        if let doneButtonDelegate = doneButtonDelegate, let request = request { doneButtonDelegate.doneTapped(request: request) }
        else { performSegue(withIdentifier: RequestDateVC.id, sender: nil) }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
            guard let requestHolder = segue.destination as? RequestHolder else { return }
            requestHolder.setRequestData(request: request, doneButtonDelegate: nil)
        
    }
}

extension RequestLocationVC: RequestHolder {
    func setRequestData(request: Request?, doneButtonDelegate: RequestDoneButtonDelegate?) {
        self.request = request
        self.doneButtonDelegate = doneButtonDelegate
    }
}

extension RequestLocationVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations.first!
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(userLocation, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?.first
            var fullAddress = ""
            // Street address
            if let street = placeMark.addressDictionary!["Thoroughfare"] as? String {
                fullAddress = street
            }
            
            // City
            if let city = placeMark.addressDictionary!["City"] as? String {
                fullAddress = fullAddress + ", \(city)"
            }
            
            // Zip code
            if let zip = placeMark.addressDictionary!["ZIP"] as? String {
                fullAddress = fullAddress + ", \(zip)"
            }
            
            // Country
            if let country = placeMark.addressDictionary!["Country"] as? String {
                fullAddress = fullAddress + ", \(country)"
            }
            self.myPlaceAddressTextField.text = fullAddress
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
