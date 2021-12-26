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
    let mainViewControllerFactory: () -> MainViewController
    let splashViewControllerFactory: () -> SplashViewController
}

extension DIViewController {
    static func resolve() -> DIViewController {
        
        let diViewModel = DIViewModel.resolve()
        
        let loginViewControllerFactory: () -> LoginViewController = {
            return .init(loginViewModel: diViewModel.loginViewModelFactory())
        }
        
        let signUpViewControllerFactory: () -> SignUpViewController = {
            return .init(signUpViewModel: diViewModel.signUpViewModelFactory())
        }
        
        let mainViewControllerFactory: () -> MainViewController = { .init(nibName: nil, bundle: nil) }
        let splashViewControllerFactory: () -> SplashViewController = { .init(splashViewModel: diViewModel.splashViewModelFactory()) }
        
        return .init(loginViewControllerFactory: loginViewControllerFactory, signUpViewControllerFactory: signUpViewControllerFactory, mainViewControllerFactory: mainViewControllerFactory, splashViewControllerFactory: splashViewControllerFactory)
    }
}
