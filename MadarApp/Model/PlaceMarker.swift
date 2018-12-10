//
//  PlaceMarker.swift
//  MadarApp
//
//  Created by Ibrahim El-geddawy on 10/1/18.
//  Copyright © 2018 Jiddawi. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class PlaceMarker: GMSMarker {
    let place: GooglePlace
    
    init(place: GooglePlace) {
        self.place = place
        super.init()
        
        position = place.coordinate
        icon = UIImage(named: place.name + "_pin")
        groundAnchor = CGPoint(x: 0.5, y: 1)
        appearAnimation = .pop
    }
}
