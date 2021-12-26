//
//  CustomPointAnnotation.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import Foundation
import CoreLocation
import MapKit

class CustomPointAnnotation: NSObject, MKAnnotation, Identifiable {
    
    dynamic var coordinate: CLLocationCoordinate2D
    let id: String
    
    init(id: String, coordinate: CLLocationCoordinate2D) {
        self.id = id
        self.coordinate = coordinate
        super.init()
    }
    
    func updateCoordinator(coordinate: CLLocationCoordinate2D) {
        UIView.animate(withDuration: 0.5) {
            self.coordinate = coordinate
        }
    }
}
