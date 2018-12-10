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

    @IBOutlet weak var addressLabel_lbl: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    private let locationManager = CLLocationManager()
    var myPosition : CLLocationCoordinate2D?
    var targetPosition : CLLocationCoordinate2D?
    var searchedTypes : [String] = ["mosque", "bank"]
    private let dataProvider = GoogleDataProvider()
    private let searchRadius: Double = 25000
    var marker : GMSMarker?
    override func viewDidLoad() {
        super.viewDidLoad()
        googleInit()
    }
    // MARK:- Getting NearbyPlaces Function
    private func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D, types: [String]) {
        mapView.clear()
        dataProvider.fetchPlacesNearCoordinate(coordinate, radius:searchRadius, types: types) { places in
            places.forEach {
                print(places.count)
                let marker = PlaceMarker(place: $0)
                marker.map = self.mapView
            }
        }
    }
    // MARK:- ReverseGeocodCoordinate

    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
                let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            self.addressLabel_lbl.text = lines.joined(separator: "\n")
            
            let labelHeight = self.addressLabel_lbl.intrinsicContentSize.height
            self.mapView.padding = UIEdgeInsets(top: self.view.safeAreaInsets.top, left: 0,
                                                bottom: labelHeight, right: 0)
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
    // MARK:- Delegation
    func googleInit(){
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self

    }

    @IBAction func nearbyBanksPlaces(_ sender: Any) {
        print("ffffffffffffffffffffffff")
        fetchNearbyPlaces(coordinate: mapView.camera.target, types: ["bank"])

    }
    @IBAction func nearbyMisjidPlaces(_ sender: Any) {
        fetchNearbyPlaces(coordinate: mapView.camera.target, types: ["mosque"])

    }
    
}


// MARK:- CLLocationManagerDelegate
extension MapViewCV: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
        
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        self.myPosition = location.coordinate
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 12, bearing: 0, viewingAngle: 0)
        fetchNearbyPlaces(coordinate: location.coordinate, types: searchedTypes)

        locationManager.stopUpdatingLocation()
    }
}
// MARK: - GMSMapViewDelegate
extension MapViewCV: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocodeCoordinate(position.target)    }
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        addressLabel_lbl.lock()
    }
   
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        self.targetPosition = marker.position
        if(UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.open(URL(string:"comgooglemaps://?saddr=\(myPosition?.latitude),\(myPosition?.longitude)&daddr=\(targetPosition?.latitude),\(targetPosition?.longitude)")!, options: [:], completionHandler: nil)
        }else{
            UIApplication.shared.open(URL(string:"https://www.google.com/maps/dir/?saddr=\(myPosition?.latitude),\(myPosition?.longitude)&daddr=\(targetPosition?.latitude),\(targetPosition?.longitude)")!, options: [:], completionHandler: nil)
        }
        return false
    }
    
}

