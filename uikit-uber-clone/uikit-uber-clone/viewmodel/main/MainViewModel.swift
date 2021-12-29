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
    @Published var trip: Trip? = nil
    @Published var myTripRequest: Trip?
    @Published var acceptedTrip: Trip?
    
    let locationManager = CLLocationManager()
    private let locationRepository: LocationRepository
    private let userRepository: UserRepository
    private let userViewModel: UserViewModel
    private let tripRepository: TripRepository
    
    private var updateCount = 0
    
    init(locationRepository: LocationRepository, userRepository: UserRepository, userViewModel: UserViewModel, tripRepository: TripRepository) {
        self.locationRepository = locationRepository
        self.userRepository = userRepository
        self.userViewModel = userViewModel
        self.tripRepository = tripRepository
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
    
    var observeNearbyUsersDisposables: Disposable?
    private func observeNearbyUsers(location: CLLocation) {
        observeNearbyUsersDisposables?.dispose()
        observeNearbyUsersDisposables = userRepository.observeNearbyUsers(center: location, radius: 10).subscribe(onNext: { [weak self] result in
            switch result {
            case .failure(let error): self?.error = error
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
        })
        observeNearbyUsersDisposables?.disposed(by: disposeBag)
    }
    
    func locationsUpdated(locations: [CLLocation]) {
        if let location = locations.first {
            self.location = location
        }
    }
    
    func cancelButtonTapped() {
        guard let trip = myTripRequest else { return }
        isLoading = true
        tripRepository.cancelTrip(trip: trip).subscribe(onNext: { [weak self] error in
            self?.isLoading = false
            self?.error = error
        }).disposed(by: disposeBag)
    }
    
    private func bind() {
        userViewModel.$user.compactMap({ $0 }).sink { [weak self] user in
            self?.userType = user.userType
            switch user.userType {
            case .DRIVER: self?.observerTrip()
            case .RIDER: self?.observeMyTrip()
            }
        }.store(in: &subscriber)
        
        $myTripRequest.compactMap({ $0 }).filter({ $0.state == .accepted }).sink { [weak self] trip in
            self?.acceptedTrip = trip
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
    
    var observeTripDisposable: Disposable?
    var observeAcceptedTripOnlyForDriverDisposable: Disposable?
    private func observerTrip() {
        guard let coordinate = locationManager.location?.coordinate else { return }
        observeTripDisposable?.dispose()
        observeAcceptedTripOnlyForDriverDisposable?.dispose()
        
        observeTripDisposable = tripRepository.observeTrip(center: .init(latitude: coordinate.latitude, longitude: coordinate.longitude), radius: 10).subscribe(onNext: { [weak self] result in
            switch result {
            case .success(let trip): self?.trip = trip
            case .failure(let error): self?.error = error
            }
        })
        observeTripDisposable?.disposed(by: disposeBag)
        
        observeAcceptedTripOnlyForDriverDisposable = tripRepository.observeAcceptedTripOnlyForDriver().subscribe(onNext: { [weak self] trip in
            self?.acceptedTrip = trip
        })
        observeAcceptedTripOnlyForDriverDisposable?.disposed(by: disposeBag)
    }
    
    private func observeMyTrip() {
        tripRepository.observeMyTrip().subscribe(onNext: { [weak self] trip in
            self?.myTripRequest = trip
        }).disposed(by: disposeBag)
    }
    
}
