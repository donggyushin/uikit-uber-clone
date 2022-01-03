//
//  UserRepositoryTest.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2022/01/03.
//

import Firebase
import RxSwift
import CoreLocation
import GeoFire

class UserRepositoryTest: UserRepository {
    
    static let shared = UserRepositoryTest()
    
    func fetchUser(uid: String, completion: @escaping (Result<UberUser, Error>) -> Void) {
        
        let data: [String: Any] = [
            "id": "1",
            "fullname": "fullname",
            "email": "email",
            "userType": "RIDER"
        ]
        
        let user: UberUser = .init(data: data)
        completion(.success(user))
    }
    
    func observeNearbyUsers(center: CLLocation, radius: Double) -> Observable<Result<UberUser, Error>> {
        return .create { observer in
            
            let data: [String: Any] = [
                "id": "1",
                "fullname": "fullname",
                "email": "email",
                "userType": "RIDER"
            ]
            
            let user: UberUser = .init(data: data)
            
            observer.onNext(.success(user))
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    func createUser(email: String, password: String, fullname: String, accountType: UserType) -> Observable<Result<User, Error>> {
        return .create { observer in
            
            let error: MyError = .unauthorized
            
            observer.onNext(.failure(error))
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    func fetchUser() -> Observable<Result<UberUser, Error>> {
        return .create { observer in
            
            let data: [String: Any] = [
                "id": "1",
                "fullname": "fullname",
                "email": "email",
                "userType": "RIDER"
            ]
            
            let user: UberUser = .init(data: data)
            
            observer.onNext(.success(user))
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    func login(email: String, password: String) -> Observable<Result<User, Error>> {
        return .create { observer in
            
            let error: MyError = .unauthorized
            
            observer.onNext(.failure(error))
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    func changeUserType(user: UberUser) -> Observable<Error?> {
        return .create { observer in
            observer.onNext(nil)
            observer.onCompleted()
            return Disposables.create()
        }
    }
}
