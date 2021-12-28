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
    
    private func tripIdDetected(uid: String, promise: @escaping (Result<Trip, Error>) -> Void) {
        // 여기서 uid는 trip의 id임. 이 id를 갖고 있는 trip을 가져와서 반환한다.
        COLLECTION_TRIP.document(uid).getDocument { snapshot, error in
            if let error = error {
                promise(.failure(error))
            } else if let data = snapshot?.data() {
                let trip: Trip = .init(passengerId: uid, data: data)
                if trip.state == .requested { promise(.success(.init(passengerId: uid, data: data))) }
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
