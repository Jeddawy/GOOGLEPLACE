////
////  NearbyPlcesProvider.swift
////  MadarApp
////
////  Created by Ibrahim El-geddawy on 10/2/18.
////  Copyright © 2018 Jiddawi. All rights reserved.
////
//
//import UIKit
//import Foundation
//import CoreLocation
//import SwiftyJSON
//import GoogleMaps
//import GooglePlaces
//
//func fetchPlacesNearCoordinate(coordinate: CLLocationCoordinate2D, radius: Double, name : String){
//    var urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=\(apiServerKey)&location=\(coordinate.latitude),\(coordinate.longitude)&radius=\(radius)&rankby=prominence&sensor=true"
//    urlString += "&name=\(name)"
//    
//    urlString = urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
//    println(urlString)
//    if placesTask.taskIdentifier > 0 && placesTask.state == .Running {
//        placesTask.cancel()
//        
//    }
//    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
//    placesTask = session.dataTaskWithURL(NSURL(string: urlString)!) {data, response, error in
//        println("inside.")
//        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
//        if let json = NSJSONSerialization.JSONObjectWithData(data, options:nil, error:nil) as? NSDictionary {
//            if let results = json["results"] as? NSArray {
//                for rawPlace:AnyObject in results {
//                    println(rawPlace)
//                    self.results.append(rawPlace as! String)
//                }
//            }
//        }
//        self.placesTask.resume()
//    }
//}
//
