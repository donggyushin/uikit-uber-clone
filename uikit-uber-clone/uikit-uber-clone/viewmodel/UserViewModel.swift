//
//  UserViewModel.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import RxSwift
import Combine

class UserViewModel {
    static let shared = UserViewModel()
    @Published var user: UberUser? = nil
}
