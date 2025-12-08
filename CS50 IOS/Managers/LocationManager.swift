//
//  LocationManager.swift
//  CS50
//
//  Created by Alejandra Briceno on 11/25/25.
//

import Foundation
import Combine
import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 42.3744, longitude: -71.1182),
        span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        //Asking user for location permissions
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           //Updating map with user's location
        guard let location = locations.last else { return }
        
        let coord = location.coordinate
        
        region = MKCoordinateRegion(
            center: coord,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    

        
        }
    }
