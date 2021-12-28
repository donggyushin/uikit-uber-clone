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
import GeoFire

class TripRepositoryImpl: TripRepository {
    static let shared = TripRepositoryImpl()
    
    private var circleQueryObserver: GFCircleQuery?
    func observeTrip(center: CLLocation, radius: Double) -> Future<Trip, Error> {
        return .init { promise in
            let geoFire = GeoFire(firebaseRef: REFERENCE_TRIP)
            self.circleQueryObserver?.removeAllObservers()
            self.circleQueryObserver = geoFire.query(at: center, withRadius: radius)
            self.circleQueryObserver?.observe(.keyEntered, with: { uid, _ in
                // 여기서 uid는 trip의 id임. 이 id를 갖고 있는 trip을 가져와서 반환한다.
                COLLECTION_TRIP.document(uid).getDocument { snapshot, error in
                    if let error = error {
                        promise(.failure(error))
                    } else if let data = snapshot?.data() {
                        promise(.success(.init(passengerId: uid, data: data)))
                    }
                }
            })
        }
    }
    
    func postTrip(pickup: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) -> Future<Bool, Error> {
        return .init { promise in
            guard let uid = Auth.auth().currentUser?.uid else {
                let error: MyError = .unauthorized
                promise(.failure(error))
                return
            }
            let data: [String: Any] = [
                "state": Trip.TripState.requested.rawValue,
                "destinationlatitude": destination.latitude,
                "destinationlongitude": destination.longitude,
                "pickuplatitude": pickup.latitude,
                "pickuplongitude": pickup.longitude
            ]
            COLLECTION_TRIP.document(uid).setData(data) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    let geoFire = GeoFire(firebaseRef: REFERENCE_TRIP)
                    geoFire.setLocation(.init(latitude: pickup.latitude, longitude: pickup.longitude), forKey: uid)
                    promise(.success(true))
                }
            }
        }
    }
}
