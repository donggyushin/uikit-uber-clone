//
//  SignUpViewModel.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import RxSwift
import Combine

class SignUpViewModel: BaseViewModel {
    
    private let userRepository: UserRepository
    private let userViewModel: UserViewModel
    @Published var user: UberUser? = nil
    
    init(userRepository: UserRepository, userViewModel: UserViewModel) {
        self.userRepository = userRepository
        self.userViewModel = userViewModel
        super.init()
    }
    
    func signUp(email: String, password: String, fullName: String, userType: UserType) {
        
        guard email.isEmpty == false && password.isEmpty == false && fullName.isEmpty == false else {
            let error: UserError = .not_enought
            self.error = error
            return
        }
        
        isLoading = true
        userRepository.createUser(email: email, password: password, fullname: fullName, accountType: userType).subscribe(onNext: { [weak self] result in
            self?.isLoading = false
            switch result {
            case .failure(let error):
                self?.error = error
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
                self?.user = user
                self?.userViewModel.user = user
            case .failure(let error):
                self?.error = error
            }
        }).disposed(by: disposeBag)
    }
}
