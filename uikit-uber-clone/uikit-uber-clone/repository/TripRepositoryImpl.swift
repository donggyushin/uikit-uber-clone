//
//  TripRepositoryImpl.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/28.
//

import UIKit
import Firebase
import MapKit
import Combine

class TripRepositoryImpl: TripRepository {
    static let shared = TripRepositoryImpl()
    
    func postTrip(pickup: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) -> Future<Bool, Error> {
        return .init { promise in
            guard let uid = Auth.auth().currentUser?.uid else {
                let error: MyError = .unauthorized
                promise(.failure(error))
                return
            }
            let data: [String: Any] = [
                "pickupCoordinates": [pickup.latitude, pickup.longitude],
                "destinationCoordinates": [destination.latitude, destination.longitude]
            ]
            COLLECTION_TRIP.document(uid).setData(data) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(true))
                }
            }
        }
    }
}
