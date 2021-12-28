//
//  RideRequestViewModel.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/27.
//

import MapKit
import Combine

class RideRequestViewModel: BaseViewModel {
    @Published var placemark: MKPlacemark
    @Published var requestSuccess = false
    private let tripRepository: TripRepository
    
    init(placemark: MKPlacemark, tripRepository: TripRepository) {
        self.placemark = placemark
        self.tripRepository = tripRepository
    }
    
    func confirmButtonTapped(mapView: MKMapView) {
        isLoading = true
        tripRepository.postTrip(pickup: mapView.userLocation.coordinate, destination: placemark.coordinate).sink { [weak self] promise in
            self?.isLoading = false
            switch promise {
            case .failure(let error):
                self?.error = error
            case .finished:
                print("DEBUG: posting trip was success!")
            }
        } receiveValue: { _ in
            self.requestSuccess = true
        }.store(in: &subscriber)

    }
}
