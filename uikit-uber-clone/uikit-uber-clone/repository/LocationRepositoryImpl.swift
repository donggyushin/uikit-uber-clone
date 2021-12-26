//
//  LocationRepositoryImpl.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import GeoFire
import Firebase

class LocationRepositoryImpl: LocationRepository {
    static let shared = LocationRepositoryImpl()
    
    func updateLocation(location: CLLocation) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let geoFire = GeoFire(firebaseRef: REFERENCE_LOCATION)
        geoFire.setLocation(location, forKey: uid)
    }
}
