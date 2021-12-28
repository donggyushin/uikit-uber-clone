//
//  UserRepositoryImpl.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import Firebase
import RxSwift
import CoreLocation
import GeoFire

class UserRepositoryImpl: UserRepository {
    
    static let shared = UserRepositoryImpl()
    
    func fetchUser(uid: String, completion: @escaping (Result<UberUser, Error>) -> Void) {
        COLLECTION_USER.document(uid).getDocument { snapshot, error in
            if let error = error {
                return completion(.failure(error))
            } else if let data = snapshot?.data() {
                return completion(.success(.init(data: data)))
            }
        }
    }
    
    private var circleQueryObserver: GFCircleQuery?
    
    func observeNearbyUsers(center: CLLocation, radius: Double, completion: @escaping (Result<UberUser, Error>) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let geoFire = GeoFire(firebaseRef: REFERENCE_LOCATION)
        circleQueryObserver?.removeAllObservers()
        circleQueryObserver = geoFire.query(at: center, withRadius: radius)
        
        circleQueryObserver?.observe(.keyEntered, with: { uid, location in
            self.locationDetected(uid: uid, currentUid: currentUid, location: location, completion: completion)
        })
        
        circleQueryObserver?.observe(.keyMoved, with: { uid, location in
            self.locationDetected(uid: uid, currentUid: currentUid, location: location, completion: completion)
        })
    }
    
    private func locationDetected(uid: String, currentUid: String, location: CLLocation, completion: @escaping (Result<UberUser, Error>) -> Void) {
        if uid != currentUid {
            self.fetchUser(uid: uid) { result in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(var user):
                    user.location = location
                    completion(.success(user))
                }
            }
        }
    }
    
    func login(email: String, password: String) -> Observable<Result<User, Error>> {
        return .create { observer in
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let error = error {
                    observer.onNext(.failure(error))
                } else if let user = result?.user {
                    observer.onNext(.success(user))
                } else {
                    let error: MyError = .unknown
                    observer.onNext(.failure(error))
                }
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    func fetchUser() -> Observable<Result<UberUser, Error>> {
        return .create { observer in
            
            guard let uid = Auth.auth().currentUser?.uid else {
                let error: UserError = .no_uid
                observer.onNext(.failure(error))
                observer.onCompleted()
                return Disposables.create() }
            
            COLLECTION_USER.document(uid).getDocument { snapsnot, error in
                if let error = error {
                    observer.onNext(.failure(error))
                    observer.onCompleted()
                } else if let data = snapsnot?.data() {
                    let user: UberUser = .init(data: data)
                    observer.onNext(.success(user))
                    observer.onCompleted()
                } else {
                    let error: MyError = .unknown
                    observer.onNext(.failure(error))
                    observer.onCompleted()
                }
            }
            
            return Disposables.create()
        }
    }
    
    func createUser(email: String, password: String, fullname: String, accountType: UserType) -> Observable<Result<User, Error>> {
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
                        "accountType": accountType.rawValue
                    ]
                    
                    COLLECTION_USER.document(user.uid).setData(data) { error  in
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
