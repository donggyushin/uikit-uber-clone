//
//  DIRepository.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

struct DIRepository {
    let userRepository: UserRepository
}

extension DIRepository {
    static func resolve() -> DIRepository {
        
        let userRepository: UserRepository = UserRepositoryImpl.shared
        
        return .init(userRepository: userRepository)
    }
}
