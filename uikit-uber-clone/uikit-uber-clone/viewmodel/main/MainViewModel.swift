//
//  MainViewModel.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import Foundation
import CoreLocation
import RxSwift
import MapKit

class MainViewModel: BaseViewModel {
    
    @Published var needLocationPermission = false
    @Published var location: CLLocation? = nil
    @Published var nearbyUsers: [UberUser] = []
    @Published var destination: DestinationPointAnnotation? = nil
    @Published var isUserCenter = true
    @Published var userTrackingMode: MKUserTrackingMode = .follow
    @Published var userType: UserType = .DRIVER
    
    let locationManager = CLLocationManager()
    private let locationRepository: LocationRepository
    private let userRepository: UserRepository
    private let userViewModel: UserViewModel
    
    private var updateCount = 0
    
    init(locationRepository: LocationRepository, userRepository: UserRepository, userViewModel: UserViewModel) {
        self.locationRepository = locationRepository
        self.userRepository = userRepository
        self.userViewModel = userViewModel
        super.init()
        enableLocation()
        requestGPSPermission()
        bind()
        
        if let location = locationManager.location {
            self.locationUpdated(location: location)
        }
    }
    
    func userMovedScreen(value: Int) {
        self.isUserCenter = value != 0
    }
    
    func setDestination(place: MKPlacemark) {
        destination = DestinationPointAnnotation(id: place.title ?? "", coordinate: place.coordinate)
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
        userViewModel.$user.compactMap({ $0 }).sink { [weak self] user in
            self?.userType = user.userType
        }.store(in: &subscriber)
        
        $location.compactMap({ $0 }).sink { [weak self] location in
            self?.locationUpdated(location: location)
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
