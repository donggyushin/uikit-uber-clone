//
//  UserRepositoryImpl.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import Firebase
import RxSwift

class UserRepositoryImpl: UserRepository {
    
    static let shared = UserRepositoryImpl()
    
    func createUser(email: String, password: String, fullname: String, accountType: Int) -> Observable<Result<User, Error>> {
        return .create { observer in
            
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    observer.onNext(.failure(error))
                    observer.onCompleted()
                }else if let user = result?.user {
                    let data: [String: Any] = [
                        "uid": user.uid,
                        "email": email,
                        "fullname": fullname,
                        "accountType": accountType == 0 ? "RIDER" : "DRIVER"
                    ]
                    COLLECTION_USER.addDocument(data: data) { error in
                        if let error = error {
                            observer.onNext(.failure(error))
                        } else {
                            observer.onNext(.success(user))
                        }
                        observer.onCompleted()
                    }
                } else {
                    let error: MyError = .unknown
                    observer.onNext(.failure(error))
                    observer.onCompleted()
                }
            }
            
            return Disposables.create()
        }
    }
}
