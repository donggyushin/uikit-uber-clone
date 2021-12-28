//
//  TripRepository.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/28.
//

import Combine
import MapKit

protocol TripRepository {
    func postTrip(pickup: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) -> Future<Bool, Error>
    func observeTrip(center: CLLocation, radius: Double) -> Future<Trip, Error>
}
