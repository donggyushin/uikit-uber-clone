//
//  TripRepositoryTest.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2022/01/03.
//

import MapKit
import Combine
import RxSwift

class TripRepositoryTest: TripRepository {
    
    static let shared = TripRepositoryTest()
    
    func postTrip(pickup: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) -> Future<Bool, Error> {
        return .init { promise in
            promise(.success(true))
        }
    }
    
    func observeTrip(center: CLLocation, radius: Double) -> Observable<Result<Trip, Error>> {
        return .create { observer in
            observer.onNext(.success(.init(passengerId: "1", data: [:])))
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func acceptTrip(trip: Trip) -> Observable<Error?> {
        return .create { observer in
            observer.onNext(nil)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func observeMyTrip() -> Observable<Trip> {
        return .create { observer in
            observer.onNext(.init(passengerId: "1", data: [:]))
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func observeTrip(trip: Trip) -> Observable<Trip> {
        return .create { observer in
            observer.onNext(.init(passengerId: "1", data: [:]))
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func cancelTrip(trip: Trip) -> Observable<Error?> {
        return .create { observer in
            observer.onNext(nil)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func observeAcceptedTripOnlyForDriver() -> Observable<Trip> {
        return .create { observer in
            observer.onNext(.init(passengerId: "1", data: [:]))
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func completeTrip(trip: Trip) -> Observable<Error?> {
        return .create { observer in
            observer.onNext(nil)
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    
}
