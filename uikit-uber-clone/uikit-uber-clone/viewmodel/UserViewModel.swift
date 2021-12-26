//
//  UserViewModel.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import RxSwift

class UserViewModel {
    static let shared = UserViewModel()
    let user: BehaviorSubject<UberUser?> = .init(value: nil)
}
