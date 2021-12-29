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
    let pickupViewControllerFactory: (Trip) -> PickupViewController
    let matchedViewControllerFactory: (Trip) -> MatchedViewController
}

extension DIViewController {
    static func resolve() -> DIViewController {
        
        let diViewModel = DIViewModel.resolve()
        let diUtil = DIUtil.resolve()
        
        let loginViewControllerFactory: () -> LoginViewController = {
            return .init(loginViewModel: diViewModel.loginViewModelFactory())
        }
        
        let signUpViewControllerFactory: () -> SignUpViewController = {
            return .init(signUpViewModel: diViewModel.signUpViewModelFactory())
        }
        
        let mainViewControllerFactory: () -> MainViewController = { .init(mainViewModel: diViewModel.mainViewModelFactory(), linkUtil: diUtil.linkUtil, mapKitUtik: diUtil.mapKitUtil) }
        
        let splashViewControllerFactory: () -> SplashViewController = { .init(splashViewModel: diViewModel.splashViewModelFactory()) }
        
        let pickupViewControllerFactory: (Trip) -> PickupViewController = { trip in
            return .init(viewModel: diViewModel.pickupViewModelFactory(trip))
        }
        
        let matchedViewControllerFactory: (Trip) -> MatchedViewController = { trip in
            return .init(viewModel: diViewModel.matchedViewModelFactory(trip))
        }
        
        return .init(loginViewControllerFactory: loginViewControllerFactory, signUpViewControllerFactory: signUpViewControllerFactory, mainViewControllerFactory: mainViewControllerFactory, splashViewControllerFactory: splashViewControllerFactory, pickupViewControllerFactory: pickupViewControllerFactory, matchedViewControllerFactory: matchedViewControllerFactory)
    }
}
