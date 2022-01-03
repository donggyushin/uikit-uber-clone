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
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
        super.init()
        checkLogin()
    }
    
    private func checkLogin() {
        print("[test] 요긴 오겠지")
        userRepository.fetchUser().subscribe(onNext: { [weak self] result in
            print("[test] 여길 안오는건가?")
            switch result {
            case .success(let user):
                self?.navigationType = .home
                UserViewModel.shared.user = user
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
