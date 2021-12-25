//
//  UserRepository.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import Firebase
import RxSwift

protocol UserRepository {
    func createUser(email: String, password: String, fullname: String, accountType: Int) -> Observable<Result<User, Error>>
}
