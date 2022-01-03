//
//  LoginViewModel.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import RxSwift
import Combine

class LoginViewModel: BaseViewModel {
    @Published var user: UberUser? = nil
    
    private let userRepository: UserRepository
    private let userViewModel: UserViewModel
    
    init(userRepository: UserRepository, userViewModel: UserViewModel) {
        self.userRepository = userRepository
        self.userViewModel = userViewModel
        super.init()
    }
    
    func login(email: String, password: String) {
        isLoading = true
        userRepository.login(email: email, password: password).subscribe(onNext: { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success:
                self?.fetchUser()
            case .failure(let error):
                self?.error = error
            }
        }).disposed(by: disposeBag)
    }
    
    private func fetchUser() {
        userRepository.fetchUser().subscribe(onNext: { [weak self] result in
            switch result {
            case .failure(let error):
                self?.error = error
            case .success(let user):
                self?.userViewModel.user = user 
                self?.user = user
            }
        }).disposed(by: disposeBag)
    }
}
