//
//  SideMenuViewModel.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2022/01/03.
//

import Combine
import Firebase

class SideMenuViewModel: BaseViewModel {
    private let userViewModel: UserViewModel
    private var isFirstToggleEvent = true
    
    @Published var user: UberUser?
    @Published var isLogout = false
    
    init(userViewModel: UserViewModel) {
        self.userViewModel = userViewModel
        super.init()
        bind()
    }
    
    func logoutButtonTapped() {
        do {
            try Auth.auth().signOut()
            isLogout = true
        } catch {
            let error: MyError = .unknown
            self.error = error
        }
    }
    
    func toggleButtonTapped() {
        if isFirstToggleEvent {
            isFirstToggleEvent = false
            return
        }
        userViewModel.changeUserType()
    }
    
    private func bind() {
        userViewModel.$user.compactMap({ $0 }).sink { [weak self] user in
            self?.user = user
        }.store(in: &subscriber)
    }
}
