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
}

extension DIViewModel {
    static func resolve() -> DIViewModel {
        
        let diRepository = DIRepository.resolve()
        
        let userViewModel: UserViewModel = UserViewModel.shared
        
        let signUpViewModelFactory: () -> SignUpViewModel = { .init(userRepository: diRepository.userRepository) }
        
        let loginViewModelFactory: () -> LoginViewModel = { .init(userRepository: diRepository.userRepository) }
        
        let splashViewModelFactory: () -> SplashViewModel = { .init(userRepository: diRepository.userRepository) }
        
        let mainViewModelFactory: () -> MainViewModel = { .init(locationRepository: diRepository.locationRepository, userRepository: diRepository.userRepository, userViewModel: userViewModel, tripRepository: diRepository.tripRepository) }
        
        let locationTableViewModelFactory: (MKCoordinateRegion) -> LocationTableViewModel = { region in
            return .init(placeRepository: diRepository.placeRepository, region: region)
        }
        
        let rideRequestViewModelFactory: (MKPlacemark) -> RideRequestViewModel = { place in
            return .init(placemark: place, tripRepository: DIRepository.resolve().tripRepository)
        }
        
        let pickupViewModelFactory: (Trip) -> PickupViewModel = { trip in
            return .init(trip: trip, tripRepository: DIRepository.resolve().tripRepository)
        }
        
        return .init(userViewModel: userViewModel, signUpViewModelFactory: signUpViewModelFactory, loginViewModelFactory: loginViewModelFactory, splashViewModelFactory: splashViewModelFactory, mainViewModelFactory: mainViewModelFactory, locationTableViewModelFactory: locationTableViewModelFactory, rideRequestViewModelFactory: rideRequestViewModelFactory, pickupViewModelFactory: pickupViewModelFactory)
    }
}
