//
//  MainViewModel.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import Foundation
import CoreLocation
import RxSwift

class MainViewModel: BaseViewModel {
    
    @Published var needLocationPermission = false
    @Published var locations: [CLLocation] = []
    let locationManager = CLLocationManager()
    private let locationRepository: LocationRepository
    
    init(locationRepository: LocationRepository) {
        self.locationRepository = locationRepository
        super.init()
        enableLocation()
        requestGPSPermission()
        bind()
    }
    
    func locationsUpdated(locations: [CLLocation]) {
        self.locations = locations
    }
    
    private func bind() {
        $locations.sink { [weak self] locations in
            guard let location = locations.first else { return }
            self?.updateLocation(location: location)
        }.store(in: &subscriber)
    }
    
    private func enableLocation() {
        locationManager.requestAlwaysAuthorization()
    }
    
    private func requestGPSPermission(){
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            self.locationManager.startUpdatingHeading()
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            if let location = self.locationManager.location {
                self.updateLocation(location: location)
            }
        case .restricted, .notDetermined:
            print("GPS: 아직 선택하지 않음")
        default:
            print("DEBUG: 권한 없음")
            self.needLocationPermission = true
        }
    }
    
    private func updateLocation(location: CLLocation) {
        locationRepository.updateLocation(location: location)
    }
    
}
