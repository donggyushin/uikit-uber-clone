//
//  DIViewController.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import Foundation
import SideMenu
import UIKit

struct DIViewController {
    let loginViewControllerFactory: () -> LoginViewController
    let signUpViewControllerFactory: () -> SignUpViewController
    let mainViewControllerFactory: () -> MainViewController
    let splashViewControllerFactory: () -> SplashViewController
    let pickupViewControllerFactory: (Trip) -> PickupViewController
    let matchedViewControllerFactory: (Trip) -> MatchedViewController
    let sideMenuViewController: (MainViewModel) -> SideMenuNavigationController
}

extension DIViewController {
    static func resolve(test: Bool = false) -> DIViewController {
        
        let diViewModel = DIViewModel.resolve(test: test)
        let diUtil = DIUtil.resolve()
        
        let loginViewControllerFactory: () -> LoginViewController = {
            return .init(loginViewModel: diViewModel.loginViewModelFactory())
        }
        
        let signUpViewControllerFactory: () -> SignUpViewController = {
            return .init(signUpViewModel: diViewModel.signUpViewModelFactory())
        }
        
        let mainViewControllerFactory: () -> MainViewController = { .init(mainViewModel: diViewModel.mainViewModelFactory(), linkUtil: diUtil.linkUtil, mapKitUtik: diUtil.mapKitUtil, userViewModel: diViewModel.userViewModel) }
        
        let splashViewControllerFactory: () -> SplashViewController = { .init(splashViewModel: diViewModel.splashViewModelFactory()) }
        
        let pickupViewControllerFactory: (Trip) -> PickupViewController = { trip in
            return .init(viewModel: diViewModel.pickupViewModelFactory(trip))
        }
        
        let matchedViewControllerFactory: (Trip) -> MatchedViewController = { trip in
            return .init(viewModel: diViewModel.matchedViewModelFactory(trip))
        }
        
        let sideMenuViewController: (MainViewModel) -> SideMenuNavigationController = { mainViewModel in
            let controller: SideMenuNavigationController = .init(rootViewController: SideMenuViewController(viewModel: diViewModel.sideMenuViewModelFactory(), mainViewModel: mainViewModel))
            controller.leftSide = true
            controller.menuWidth = UIScreen.main.bounds.width - 80
            return controller
        }
        
        return .init(loginViewControllerFactory: loginViewControllerFactory, signUpViewControllerFactory: signUpViewControllerFactory, mainViewControllerFactory: mainViewControllerFactory, splashViewControllerFactory: splashViewControllerFactory, pickupViewControllerFactory: pickupViewControllerFactory, matchedViewControllerFactory: matchedViewControllerFactory, sideMenuViewController: sideMenuViewController)
    }
}
