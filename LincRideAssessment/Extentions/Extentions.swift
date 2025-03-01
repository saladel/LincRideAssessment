//
//  Extentions.swift
//  LincRideAssessment
//
//  Created by Adewale Sanusi on 28/02/2025.
//

import Foundation
import MapKit

extension CLLocationCoordinate2D {
    static var userLocation: CLLocationCoordinate2D {
        return .init(latitude: 25.7602, longitude: -80.1959)
    }
}

extension MKCoordinateRegion {
    static var userRegion: MKCoordinateRegion {
        return .init(
            center: .userLocation,
            latitudinalMeters: 10000,
            longitudinalMeters: 10000
        )
    }
}


