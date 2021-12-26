//
//  LoginViewModel.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import RxSwift

class LoginViewModel: BaseViewModel {
    let user: BehaviorSubject<UberUser?> = .init(value: nil)
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
        super.init()
    }
    
    func login(email: String, password: String) {
        isLoading.onNext(true)
        userRepository.login(email: email, password: password).subscribe(onNext: { [weak self] result in
            self?.isLoading.onNext(false)
            switch result {
            case .success:
                self?.fetchUser()
            case .failure(let error):
                self?.error.onNext(error)
            }
        }).disposed(by: disposeBag)
    }
    
    private func fetchUser() {
        userRepository.fetchUser().subscribe(onNext: { [weak self] result in
            switch result {
            case .failure(let error):
                self?.error.onNext(error)
            case .success(let user):
                self?.user.onNext(user)
            }
        }).disposed(by: disposeBag)
    }
}
