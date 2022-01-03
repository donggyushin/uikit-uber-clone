//
//  UserViewModel.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import RxSwift
import Combine

class UserViewModel: BaseViewModel {
    static let shared = UserViewModel(userRepository: UserRepositoryImpl())
    @Published var user: UberUser? = nil
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
        super.init()
    }
    
    func changeUserType() {
        guard var user = user else { return }
        userRepository.changeUserType(user: user).subscribe(onNext: { [weak self] error in
            user.userType = user.userType == .DRIVER ? .RIDER : .DRIVER
            self?.user = user
        }).disposed(by: disposeBag)
    }
}
