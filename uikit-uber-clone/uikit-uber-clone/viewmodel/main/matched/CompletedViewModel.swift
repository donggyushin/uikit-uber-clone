//
//  CompletedViewModel.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/30.
//

import UIKit
import Combine

class CompletedViewModel: BaseViewModel {
    
    private let tripRepository: TripRepository
    private let trip: Trip
    @Published var success = false
    
    init(tripRepository: TripRepository, trip: Trip) {
        self.tripRepository = tripRepository
        self.trip = trip
        super.init()
        observeTrip()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.arrivedButtonTapped()
        }
    }
    
    private func observeTrip() {
        tripRepository.observeTrip(trip: trip).subscribe(onNext: { [weak self] trip in
            self?.success = trip.state == .completed
        }).disposed(by: disposeBag)
    }
    
    func arrivedButtonTapped() {
        self.isLoading = true
        tripRepository.completeTrip(trip: trip).subscribe(onNext: { [weak self] error in
            self?.isLoading = false
            self?.error = error
        }).disposed(by: disposeBag)
    }
    
}
