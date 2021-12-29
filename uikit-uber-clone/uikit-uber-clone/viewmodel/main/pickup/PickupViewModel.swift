//
//  PickupViewModel.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/29.
//

import UIKit
import Combine

class PickupViewModel: BaseViewModel {
    @Published var trip: Trip
    @Published var success = false
    private let tripRepository: TripRepository
    
    init(trip: Trip, tripRepository: TripRepository) {
        self.trip = trip
        self.tripRepository = tripRepository
    }
    
    func acceptTrip() {
        isLoading = true
        tripRepository.acceptTrip(trip: trip).subscribe(onNext: { [weak self] error in
            self?.isLoading = false 
            self?.success = error == nil
            self?.error = error
        }).disposed(by: disposeBag)
    }
}
