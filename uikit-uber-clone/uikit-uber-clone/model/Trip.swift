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
        let pickupCoordinates = data["pickupCoordinates"] as? [CGFloat] ?? [0, 0]
        let destinationCoordinates = data["destinationCoordinates"] as? [CGFloat] ?? [0, 0]
        self.pickupCoordinates = .init(latitude: .init(pickupCoordinates[0]), longitude: pickupCoordinates[1])
        self.destinationCoordinates = .init(latitude: .init(destinationCoordinates[0]), longitude: destinationCoordinates[1])
        self.driverId = data["driverId"] as? String
        self.state = (.init(rawValue: (data["state"] as? Int ?? 0)) ?? .requested)
    }
    
    enum TripState: Int {
        case requested
        case accepted
        case inProgress
        case completed
    }
}
