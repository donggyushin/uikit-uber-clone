//
//  SignUpViewModel.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import RxSwift

class SignUpViewModel: BaseViewModel {
    
    private let userRepository: UserRepository
    let user: BehaviorSubject<UberUser?> = .init(value: nil)
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
        super.init()
    }
    
    func signUp(email: String, password: String, fullName: String, userType: UserType) {
        
        guard email.isEmpty == false && password.isEmpty == false && fullName.isEmpty == false else {
            let error: UserError = .not_enought
            self.error.onNext(error)
            return
        }
        
        isLoading.onNext(true)
        userRepository.createUser(email: email, password: password, fullname: fullName, accountType: userType).subscribe(onNext: { [weak self] result in
            self?.isLoading.onNext(false)
            switch result {
            case .failure(let error):
                self?.error.onNext(error)
            case .success(let user):
                print("DEBUG: createUser success: \(user.uid)")
                self?.fetchUser()
            }
        }).disposed(by: disposeBag)
    }
    
    private func fetchUser() {
        userRepository.fetchUser().subscribe(onNext: { [weak self] result in
            switch result {
            case .success(let user):
                self?.user.onNext(user)
            case .failure(let error):
                self?.error.onNext(error)
            }
        }).disposed(by: disposeBag)
    }
}
