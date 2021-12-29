//
//  MatchedViewModel.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/29.
//

import UIKit
import Combine

class MatchedViewModel: BaseViewModel {
    @Published var trip: Trip
    private let tripRepository: TripRepository
    
    init(trip: Trip, tripRepository: TripRepository) {
        self.trip = trip
        self.tripRepository = tripRepository
        super.init()
        observeTrip()
    }
    
    private func observeTrip() {
        tripRepository.observeTrip(trip: trip).subscribe(onNext: { [weak self] trip in
            self?.trip = trip
        }).disposed(by: disposeBag)
    }
    
    func cancelButtonTapped() {
        isLoading = true
        tripRepository.cancelTrip(trip: trip).subscribe(onNext: { [weak self] error in
            self?.isLoading = false
            self?.error = error
        }).disposed(by: disposeBag)
    }
}
