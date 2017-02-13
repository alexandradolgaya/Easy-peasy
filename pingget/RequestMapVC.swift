//
//  RequestMapVC.swift
//  pingget
//
//  Created by Igor Prysyazhnyuk on 11/17/16.
//  Copyright © 2016 Steelkiwi. All rights reserved.
//

import GoogleMaps
//import CoreLocation

class RequestMapVC: NavBarVC, RequestMapLocation {
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var backView: ViewShadow!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var distanceSlider: UISlider!
    private var locationManager: CLLocationManager!
    var location: CLLocation?
    
    var address: String?
    var distance: Float { return distanceSlider.value }
    var isService : Bool? = true
    
    var distanceCircle = GMSCircle()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setMapParams()
        backView.layer.cornerRadius = 4.0
        updateLocation()
    }
    
    internal func setMapParams() {
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 10)
        setLocationPosition()
        mapView.camera = camera
        mapView.delegate = self
        
        distanceCircle.strokeColor = UIColor(redInt: 74, greenInt: 176, blueInt: 235)
        distanceCircle.fillColor = UIColor(redInt: 74, greenInt: 176, blueInt: 235, alpha: 0.2)
        distanceCircle.map = mapView
        
        setDistanceCircleRadius()
    }
    
    private func updateLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    internal func setAddressFrom(location: CLLocation) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?.first
            
            // Address
            let identifier = self.isService == true ? "unwindToRequestLocation" : "unwindToRequestLocation"
            if let name = placeMark.addressDictionary!["Name"] as? String {
                self.address = name
                self.performSegue(withIdentifier: identifier, sender: nil)
            }
            else {
                self.performSegue(withIdentifier: identifier, sender: nil)
            }
        })
    }
    
    private func setDistanceCircleRadius() {
        distanceCircle.radius = Double(distanceSlider.value * 1000)
    }
    
    @IBAction func cancelTapped(_ sender: AnyObject) {
        back()
    }
    
    @IBAction func distanceChanged(_ sender: AnyObject) {
        setDistanceCircleRadius()
    }
    
    @IBAction func useMyCurrentLocationPressed(_ sender: Any) {
        guard let lc = location else {
            updateLocation()
            return
        }
        setAddressFrom(location: lc)
    }
    
    @IBAction func setLocationTapped(_ sender: AnyObject) {
//        address = "Oberweg 8, 3013 Bern, Switzerland"
        location = CLLocation.init(latitude: mapView.camera.target.latitude, longitude: mapView.camera.target.longitude)
        setAddressFrom(location: location!)
//        performSegue(withIdentifier: "unwindToRequestLocation", sender: nil)
    }
}

extension RequestMapVC: GMSMapViewDelegate {
    func setLocationPosition() {
        let cameraPosition = mapView.camera.target
        distanceCircle.position = cameraPosition
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
//        location = CLLocation.init(latitude: mapView.camera.target.latitude, longitude: mapView.camera.target.longitude)
//        setAddressFrom(location: location!)
        setLocationPosition()
    }
}

extension RequestMapVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        location = locations.first!
        setMapParams()
//        setAddressFrom(location: location!)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        location = CLLocation.init(latitude: 0, longitude: 0)
        setMapParams()
    }
    
}
