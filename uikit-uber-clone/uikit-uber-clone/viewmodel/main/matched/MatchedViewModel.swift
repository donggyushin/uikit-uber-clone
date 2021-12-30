//
//  MatchedViewModel.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/29.
//

import UIKit
import Combine
import MapKit

class MatchedViewModel: BaseViewModel {
    @Published var trip: Trip
    @Published var arrived = false
    @Published private var userlocation: CLLocationCoordinate2D?
    @Published private var distance: CLLocationDistance?
    private let tripRepository: TripRepository
    private let userViewModel: UserViewModel
    
    init(trip: Trip, tripRepository: TripRepository, userViewModel: UserViewModel) {
        self.trip = trip
        self.tripRepository = tripRepository
        self.userViewModel = userViewModel
        super.init()
        observeTrip()
        bind()
    }
    
    private func bind() {
        $userlocation.compactMap({ $0 }).sink { [weak self] location in
            guard let trip = self?.trip else { return }
            let destination = CLLocation(latitude: trip.destinationCoordinates.latitude, longitude: trip.destinationCoordinates.longitude)
            let user = CLLocation(latitude: location.latitude, longitude: location.longitude)
            let distance = destination.distance(from: user)
            self?.distance = distance
        }.store(in: &subscriber)
        
        $distance.compactMap({ $0 }).sink { [weak self] distance in
            guard self?.userViewModel.user?.userType == .RIDER else { return }
            if self?.arrived == true { return }
            self?.arrived = distance <= 100
        }.store(in: &subscriber)
    }
    
    private func observeTrip() {
        tripRepository.observeTrip(trip: trip).subscribe(onNext: { [weak self] trip in
            self?.trip = trip
        }).disposed(by: disposeBag)
    }
    
    func userlocationChanged(userLocation: CLLocationCoordinate2D) {
        self.userlocation = userLocation
    }
    
    func cancelButtonTapped() {
        isLoading = true
        tripRepository.cancelTrip(trip: trip).subscribe(onNext: { [weak self] error in
            self?.isLoading = false
            self?.error = error
        }).disposed(by: disposeBag)
    }
}
