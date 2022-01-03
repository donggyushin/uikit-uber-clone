//
//  DIViewModel.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import MapKit


struct DIViewModel {
    let userViewModel: UserViewModel
    let signUpViewModelFactory: () -> SignUpViewModel
    let loginViewModelFactory: () -> LoginViewModel
    let splashViewModelFactory: () -> SplashViewModel
    let mainViewModelFactory: () -> MainViewModel
    let locationTableViewModelFactory: (MKCoordinateRegion) -> LocationTableViewModel
    let rideRequestViewModelFactory: (MKPlacemark) -> RideRequestViewModel
    let pickupViewModelFactory: (Trip) -> PickupViewModel
    let matchedViewModelFactory: (Trip) -> MatchedViewModel
    let completedViewModelFactory: (Trip) -> CompletedViewModel
    let sideMenuViewModelFactory: () -> SideMenuViewModel
}

extension DIViewModel {
    static func resolve(test: Bool = false) -> DIViewModel {
        
        let diRepository = DIRepository.resolve(test: test)
        
        let userViewModel: UserViewModel = test ? UserViewModel(userRepository: diRepository.userRepository) : UserViewModel.shared
        
        let signUpViewModelFactory: () -> SignUpViewModel = { .init(userRepository: diRepository.userRepository, userViewModel: userViewModel) }
        
        let loginViewModelFactory: () -> LoginViewModel = { .init(userRepository: diRepository.userRepository, userViewModel: userViewModel) }
        
        let splashViewModelFactory: () -> SplashViewModel = { .init(userRepository: diRepository.userRepository, userViewModel: userViewModel) }
        
        let mainViewModelFactory: () -> MainViewModel = { .init(locationRepository: diRepository.locationRepository, userRepository: diRepository.userRepository, userViewModel: userViewModel, tripRepository: diRepository.tripRepository) }
        
        let locationTableViewModelFactory: (MKCoordinateRegion) -> LocationTableViewModel = { region in
            return .init(placeRepository: diRepository.placeRepository, region: region)
        }
        
        let rideRequestViewModelFactory: (MKPlacemark) -> RideRequestViewModel = { place in
            return .init(placemark: place, tripRepository: diRepository.tripRepository)
        }
        
        let pickupViewModelFactory: (Trip) -> PickupViewModel = { trip in
            return .init(trip: trip, tripRepository: diRepository.tripRepository)
        }
        
        let matchedViewModelFactory: (Trip) -> MatchedViewModel = { trip in
            return .init(trip: trip, tripRepository: diRepository.tripRepository, userViewModel: userViewModel)
        }
        
        let completedViewModelFactory: (Trip) -> CompletedViewModel = { trip in
            return .init(tripRepository: diRepository.tripRepository, trip: trip)
        }
        
        let sideMenuViewModelFactory: () -> SideMenuViewModel = {
            return .init(userViewModel: userViewModel)
        }
        
        return .init(userViewModel: userViewModel, signUpViewModelFactory: signUpViewModelFactory, loginViewModelFactory: loginViewModelFactory, splashViewModelFactory: splashViewModelFactory, mainViewModelFactory: mainViewModelFactory, locationTableViewModelFactory: locationTableViewModelFactory, rideRequestViewModelFactory: rideRequestViewModelFactory, pickupViewModelFactory: pickupViewModelFactory, matchedViewModelFactory: matchedViewModelFactory, completedViewModelFactory: completedViewModelFactory, sideMenuViewModelFactory: sideMenuViewModelFactory)
    }
}
