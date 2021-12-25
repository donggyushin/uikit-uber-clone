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
            return .init()
        }
        
        let signUpViewControllerFactory: () -> SignUpViewController = {
            return .init()
        }
        
        return .init(loginViewControllerFactory: loginViewControllerFactory, signUpViewControllerFactory: signUpViewControllerFactory)
    }
}