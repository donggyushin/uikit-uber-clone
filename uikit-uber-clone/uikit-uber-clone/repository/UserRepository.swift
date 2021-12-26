//
//  UserRepository.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import Firebase
import RxSwift

protocol UserRepository {
    func createUser(email: String, password: String, fullname: String, accountType: UserType) -> Observable<Result<User, Error>>
    
    func fetchUser() -> Observable<Result<UberUser, Error>>
    
    func login(email: String, password: String) -> Observable<Result<User, Error>>
}
