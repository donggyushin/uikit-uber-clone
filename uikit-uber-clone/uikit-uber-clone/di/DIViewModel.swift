//
//  DIViewModel.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//


struct DIViewModel {
    let signUpViewModelFactory: () -> SignUpViewModel
    let loginViewModelFactory: () -> LoginViewModel
    let splashViewModelFactory: () -> SplashViewModel
    let mainViewModelFactory: () -> MainViewModel
}

extension DIViewModel {
    static func resolve() -> DIViewModel {
        
        let diRepository = DIRepository.resolve()
        
        let signUpViewModelFactory: () -> SignUpViewModel = { .init(userRepository: diRepository.userRepository) }
        
        let loginViewModelFactory: () -> LoginViewModel = { .init(userRepository: diRepository.userRepository) }
        
        let splashViewModelFactory: () -> SplashViewModel = { .init(userRepository: diRepository.userRepository) }
        
        let mainViewModelFactory: () -> MainViewModel = { .init(locationRepository: diRepository.locationRepository, userRepository: diRepository.userRepository) }
        
        return .init(signUpViewModelFactory: signUpViewModelFactory, loginViewModelFactory: loginViewModelFactory, splashViewModelFactory: splashViewModelFactory, mainViewModelFactory: mainViewModelFactory)
    }
}
