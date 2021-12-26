//
//  MainViewModel.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import Foundation
import CoreLocation
import RxSwift

class MainViewModel: BaseViewModel {
    
    let needLocationPermission: BehaviorSubject<Bool> = .init(value: false)
    let locationManager = CLLocationManager()
    let locations: BehaviorSubject<[CLLocation]> = .init(value: [])
    
    override init() {
        super.init()
        enableLocation()
        requestGPSPermission()
    }
    
    func locationsUpdated(locations: [CLLocation]) {
        self.locations.onNext(locations)
    }
    
    private func enableLocation() {
        locationManager.requestAlwaysAuthorization()
    }
    
    private func requestGPSPermission(){
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            print("GPS: 권한 있음")
            self.locationManager.startUpdatingHeading()
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        case .restricted, .notDetermined:
            print("GPS: 아직 선택하지 않음")
        default:
            print("DEBUG: 권한 없음")
            self.needLocationPermission.onNext(true)
        }
    }
    
}
