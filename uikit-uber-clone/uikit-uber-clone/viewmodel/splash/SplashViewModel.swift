//
//  SplashViewModel.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import RxSwift
import Combine

class SplashViewModel: BaseViewModel {
    
    @Published var navigationType: NavigationType? = nil
    
    private let userRepository: UserRepository
    private let userViewModel: UserViewModel
    
    init(userRepository: UserRepository, userViewModel: UserViewModel) {
        self.userRepository = userRepository
        self.userViewModel = userViewModel
        super.init()
        checkLogin()
    }
    
    private func checkLogin() {
        userRepository.fetchUser().subscribe(onNext: { [weak self] result in
            switch result {
            case .success(let user):
                self?.navigationType = .home
                self?.userViewModel.user = user
            case .failure:
                self?.navigationType = .auth
            }
        }).disposed(by: disposeBag)
    }
    
    enum NavigationType {
        case auth
        case home
    }
}
