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
    @Published var location: CLLocation? = nil
    @Published var nearbyUsers: [UberUser] = []
    
    let locationManager = CLLocationManager()
    private let locationRepository: LocationRepository
    private let userRepository: UserRepository
    
    private var updateCount = 0
    
    init(locationRepository: LocationRepository, userRepository: UserRepository) {
        self.locationRepository = locationRepository
        self.userRepository = userRepository
        super.init()
        enableLocation()
        requestGPSPermission()
        bind()
        
        if let location = locationManager.location {
            self.locationUpdated(location: location)
        }
    }
    
    private func observeNearbyUsers(location: CLLocation) {
        userRepository.observeNearbyUsers(center: location, radius: 1) { [weak self] result in
            switch result {
            case .failure(let error):
                print("DEBUG: error: \(error.localizedDescription)")
            case .success(let user):
                if let existingUser = self?.nearbyUsers.enumerated().first(where: { $1 == user }) {
                    var userToUpdate = existingUser.element
                    userToUpdate.location = user.location
                    self?.nearbyUsers.remove(at: existingUser.offset)
                    self?.nearbyUsers.append(userToUpdate)
                } else {
                    self?.nearbyUsers.append(user)
                }
                
            }
        }
    }
    
    func locationsUpdated(locations: [CLLocation]) {
        if let location = locations.first {
            self.location = location
        }
    }
    
    private func bind() {
        
        $location.sink { [weak self] location in
            guard let location = location else { return }
            if self?.updateCount == 0 {
                self?.locationUpdated(location: location)
            }
            self?.updateCount += 1
            if self?.updateCount ?? 0 > 10 {
                self?.updateCount = 0
            }
            
        }.store(in: &subscriber)
    }
    
    private func enableLocation() {
        locationManager.requestAlwaysAuthorization()
    }
    
    private func requestGPSPermission(){
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
            
        case .restricted, .notDetermined:
            print("GPS: 아직 선택하지 않음")
        default:
            print("DEBUG: 권한 없음")
            self.needLocationPermission = true
        }
    }
    
    private func locationUpdated(location: CLLocation) {
        self.observeNearbyUsers(location: location)
        self.locationRepository.updateLocation(location: location)
    }
    
}
