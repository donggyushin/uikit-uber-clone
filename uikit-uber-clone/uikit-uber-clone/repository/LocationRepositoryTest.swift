//
//  LocationRepositoryTest.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2022/01/03.
//

import MapKit

class LocationRepositoryTest: LocationRepository {
    func updateLocation(location: CLLocation) {}
    
    static let shared = LocationRepositoryTest()
    
}
