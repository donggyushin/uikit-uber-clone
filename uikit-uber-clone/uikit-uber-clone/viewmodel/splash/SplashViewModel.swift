//
//  SplashViewModel.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import RxSwift

class SplashViewModel: BaseViewModel {
    
    let navigationType: BehaviorSubject<NavigationType?> = .init(value: nil)
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
        super.init()
        checkLogin()
    }
    
    private func checkLogin() {
        userRepository.fetchUser().subscribe(onNext: { [weak self] result in
            switch result {
            case .success: self?.navigationType.onNext(.home)
            case .failure: self?.navigationType.onNext(.auth)
            }
        }).disposed(by: disposeBag)
    }
    
    enum NavigationType {
        case auth
        case home
    }
}
