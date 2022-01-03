//
//  DIRepository.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

struct DIRepository {
    let userRepository: UserRepository
    let locationRepository: LocationRepository
    let placeRepository: PlaceRepository
    let tripRepository: TripRepository
}

extension DIRepository {
    static func resolve(test: Bool = false) -> DIRepository {
        
        let userRepository: UserRepository = test ? UserRepositoryTest.shared : UserRepositoryImpl.shared
        let locationRepository: LocationRepository = test ? LocationRepositoryTest.shared : LocationRepositoryImpl.shared
        let placeRepository: PlaceRepository = test ? PlaceRepositoryTest.shared : PlaceRepositoryImpl.shared
        let tripRepository: TripRepository = test ? TripRepositoryTest.shared : TripRepositoryImpl.shared
        
        return .init(userRepository: userRepository, locationRepository: locationRepository, placeRepository: placeRepository, tripRepository: tripRepository)
    }
}
