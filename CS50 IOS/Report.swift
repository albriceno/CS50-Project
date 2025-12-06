//
//  Report.swift
//  CS50
//
//  Created by Olivia Jimenez on 11/29/25.
//

// Customize later

import Foundation
import CoreLocation

struct Report: Identifiable {
    let id: String
    let lat: Double
    let lng: Double
    let description: String
    let createdAt: Date
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: createdAt)
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
}
