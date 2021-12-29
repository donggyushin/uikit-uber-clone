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
import RxSwift

class TripRepositoryImpl: TripRepository {
    static let shared = TripRepositoryImpl()
    
    private var circleQueryObserver: GFCircleQuery?
    
    func observeTrip(center: CLLocation, radius: Double) -> Observable<Result<Trip, Error>> {
        
        return .create { observer in
            
            let geoFire = GeoFire(firebaseRef: REFERENCE_TRIP)
            self.circleQueryObserver?.removeAllObservers()
            self.circleQueryObserver = geoFire.query(at: center, withRadius: radius)
            self.circleQueryObserver?.observe(.keyEntered, with: { uid, _ in
                self.tripIdDetected(uid: uid, observer: observer)
            })
            self.circleQueryObserver?.observe(.keyMoved, with: { uid, _ in
                self.tripIdDetected(uid: uid, observer: observer)
            })
            
            return Disposables.create()
        }
    }
    
    private func tripIdDetected(uid: String, observer: AnyObserver<Result<Trip, Error>>) {
        COLLECTION_TRIP.document(uid).getDocument { snapshot, error in
            if let error = error {
                observer.onNext(.failure(error))
            } else if let data = snapshot?.data() {
                let trip: Trip = .init(passengerId: uid, data: data)
                if trip.state == .requested { observer.onNext(.success(trip)) }
            }
        }
    }
    
    func acceptTrip(trip: Trip) -> Observable<Error?> {
        return .create { observer in
            
            guard let uid = Auth.auth().currentUser?.uid else { return Disposables.create() }
            
            let data: [String: Any] = [
                "driverId": uid,
                "state": Trip.TripState.accepted.rawValue
            ]
            
            COLLECTION_TRIP.document(trip.passengerId).updateData(data) { error in
                observer.onNext(error)
                observer.onCompleted()
            }
            
            return Disposables.create()
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
