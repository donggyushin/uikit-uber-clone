//
//  DIViewModel.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//


struct DIViewModel {
    let signUpViewModelFactory: () -> SignUpViewModel
}

extension DIViewModel {
    static func resolve() -> DIViewModel {
        
        let signUpViewModelFactory: () -> SignUpViewModel = { .init(userRepository: DIRepository.resolve().userRepository) }
        
        return .init(signUpViewModelFactory: signUpViewModelFactory)
    }
}
