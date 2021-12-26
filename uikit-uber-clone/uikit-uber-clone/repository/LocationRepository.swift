//
//  LocationRepository.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import CoreLocation

protocol LocationRepository {
    func updateLocation(location: CLLocation)
}
