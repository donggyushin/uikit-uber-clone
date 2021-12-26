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
}

extension DIRepository {
    static func resolve() -> DIRepository {
        
        let userRepository: UserRepository = UserRepositoryImpl.shared
        let locationRepository: LocationRepository = LocationRepositoryImpl.shared
        let placeRepository: PlaceRepository = PlaceRepositoryImpl.shared
        
        return .init(userRepository: userRepository, locationRepository: locationRepository, placeRepository: placeRepository)
    }
}
