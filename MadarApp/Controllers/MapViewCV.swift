//
//  ViewController.swift
//  MadarApp
//
//  Created by Ibrahim El-geddawy on 9/30/18.
//  Copyright © 2018 Jiddawi. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapViewCV : UIViewController {

    @IBOutlet weak var pinImageVerticalConstrain: NSLayoutConstraint!
    @IBOutlet weak var addressLabel_lbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mapView: GMSMapView!
    private let locationManager = CLLocationManager()

    private let dataProvider = GMSPlace()
    private let searchRadius: Double = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        googleInit()
    }

    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        
        // 1
        let geocoder = GMSGeocoder()
        
        // 2
        self.addressLabel_lbl.unlock()

        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            
            // 3
            self.addressLabel_lbl.text = lines.joined(separator: "\n")
            
            // 1
            let labelHeight = self.addressLabel_lbl.intrinsicContentSize.height
            self.mapView.padding = UIEdgeInsets(top: self.view.safeAreaInsets.top, left: 0,
                                                bottom: labelHeight, right: 0)
            // 4
            
            UIView.animate(withDuration: 0.25) {
                //2
                self.pinImageVerticalConstrain.constant = ((labelHeight - self.view.safeAreaInsets.top) * 0.5)
                self.view.layoutIfNeeded()
            }
        }
    }
    func googleInit(){
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self

    }


}
// MARK: - CLLocationManagerDelegate
//1
extension MapViewCV: CLLocationManagerDelegate {
    // 2
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 3
        guard status == .authorizedWhenInUse else {
            return
        }
        // 4
        locationManager.startUpdatingLocation()
        
        //5
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    // 6
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        // 7
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 6, bearing: 0, viewingAngle: 0)
//        mapView.camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 6)
        // 8
        locationManager.stopUpdatingLocation()
    }
}
// MARK: - GMSMapViewDelegate
extension MapViewCV: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocodeCoordinate(position.target)
    }
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        addressLabel_lbl.lock()
    }
    
}
