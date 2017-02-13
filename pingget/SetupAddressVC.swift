//
//  SetupAddressVC.swift
//  pingget
//
//  Created by Victor on 23.12.16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import UIKit
import CoreLocation

class SetupAddressVC: NavBarVC {
    
    @IBOutlet weak var backView: ViewShadow!
    private var locationManager: CLLocationManager!
    @IBOutlet weak var streetField: TextFieldBottomLine!
    @IBOutlet weak var zipField: TextFieldBottomLine!
    @IBOutlet weak var countryField: TextFieldBottomLine!
    @IBOutlet weak var cityField: TextFieldBottomLine!
    var request: Request?
    
    static let finishSegue = "FinishSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.layer.cornerRadius = 4
        updateLocation()
        textFieldsToHideKeyboard = [streetField, zipField, countryField, cityField]
    }
    
    private func updateLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    @IBAction func finish(_ sender: AnyObject) {
        if dataIsFilled() == true {
            performSegue(withIdentifier: SetupAddressVC.finishSegue, sender: sender)
        }
    }
    
    private func dataIsFilled() -> Bool {
        var isFilled = true
        if streetField.text == "" {
            isFilled = false
        }
        if zipField.text == "" {
            isFilled = false
        }
        if countryField.text == "" {
            isFilled = false
        }
        if cityField.text == "" {
            isFilled = false
        }
        return isFilled
    }
}

extension SetupAddressVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        let userLocation: CLLocation = locations.first!
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(userLocation, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?.first

            // Street address
            if let street = placeMark.addressDictionary!["Thoroughfare"] as? String {
                self.streetField.text = street
            }
            
            // City
            if let city = placeMark.addressDictionary!["City"] as? String {
                self.cityField.text = city
            }
            
            // Zip code
            if let zip = placeMark.addressDictionary!["ZIP"] as? String {
                self.zipField.text = zip
            }
            
            // Country
            if let country = placeMark.addressDictionary!["Country"] as? String {
                self.countryField.text = country
            }
            
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }

}
