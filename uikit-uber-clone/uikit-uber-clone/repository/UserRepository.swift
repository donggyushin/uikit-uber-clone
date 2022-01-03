//
//  UserRepository.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import Firebase
import RxSwift
import GeoFire

protocol UserRepository {
    
    func fetchUser(uid: String, completion: @escaping (Result<UberUser, Error>) -> Void)
    
    func observeNearbyUsers(center: CLLocation, radius: Double) -> Observable<Result<UberUser, Error>>
    
    func createUser(email: String, password: String, fullname: String, accountType: UserType) -> Observable<Result<User, Error>>
    
    func fetchUser() -> Observable<Result<UberUser, Error>>
    
    func login(email: String, password: String) -> Observable<Result<User, Error>>
    
    func changeUserType(user: UberUser) -> Observable<Error?>
}
