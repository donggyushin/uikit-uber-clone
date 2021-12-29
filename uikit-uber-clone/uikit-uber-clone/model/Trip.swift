//
//  Trip.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/28.
//

import UIKit
import MapKit

struct Trip {
    let passengerId: String
    let pickupCoordinates: CLLocationCoordinate2D
    let destinationCoordinates: CLLocationCoordinate2D
    var driverId: String?
    var state: TripState
    
    init(passengerId: String, data: [String: Any]) {
        self.passengerId = passengerId
        self.pickupCoordinates = .init(latitude: .init(data["pickuplatitude"] as? Double ?? 0), longitude: data["pickuplongitude"] as? Double ?? 0)
        self.destinationCoordinates = .init(latitude: data["destinationlatitude"] as? Double ?? 0, longitude: data["destinationlongitude"] as? Double ?? 0)
        self.driverId = data["driverId"] as? String
        self.state = (.init(rawValue: (data["state"] as? Int ?? 0)) ?? .requested)
    }
    
    enum TripState: Int {
        case requested
        case accepted
        case canceled
        case completed
    }
}
