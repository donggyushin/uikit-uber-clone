//
//  DIViewController.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import Foundation

struct DIViewController {
    let loginViewControllerFactory: () -> LoginViewController
    let signUpViewControllerFactory: () -> SignUpViewController
}

extension DIViewController {
    static func resolve() -> DIViewController {
        
        let loginViewControllerFactory: () -> LoginViewController = {
            return .init(loginViewModel: DIViewModel.resolve().loginViewModelFactory())
        }
        
        let signUpViewControllerFactory: () -> SignUpViewController = {
            return .init(signUpViewModel: DIViewModel.resolve().signUpViewModelFactory())
        }
        
        return .init(loginViewControllerFactory: loginViewControllerFactory, signUpViewControllerFactory: signUpViewControllerFactory)
    }
}
