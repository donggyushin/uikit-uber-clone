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
    
    func observeTrip(mapView: MKMapView) -> Future<Trip, Error> {
        let currentUserLocation = mapView.userLocation.coordinate
        // latitude 최댓값
        let max_latitude = currentUserLocation.latitude + 0.05
        // latitude 최솟값
        let min_latitude = currentUserLocation.latitude - 0.05
        // longitude 최댓값
        let max_longitude = currentUserLocation.longitude + 0.05
        // longitude 최솟값
        let min_longitude = currentUserLocation.longitude + 0.05
        
        return .init { promise in
            COLLECTION_TRIP
                .whereField("pickuplatitude", isLessThan: max_latitude)
                .whereField("pickuplatitude", isGreaterThan: min_latitude)
                .whereField("pickuplongitude", isLessThan: max_longitude)
                .whereField("pickuplongitude", isGreaterThan: min_longitude)
                .addSnapshotListener { snapshot, _ in
                guard let snapshot = snapshot else { return }
                snapshot.documentChanges.filter({ $0.type == .added }).forEach({
                    promise(.success(Trip(passengerId: $0.document.documentID, data: $0.document.data())))
                })
            }
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
                "pickuplatitude": pickup.latitude,
                "pickuplongitude": pickup.longitude,
                "destinationlatitude": destination.latitude,
                "destinationlongitude": destination.longitude,
                "state": Trip.TripState.requested.rawValue
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
