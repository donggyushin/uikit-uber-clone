//
//  UberUser.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import CoreLocation
import MapKit

struct UberUser: Identifiable, Equatable {
    let id: String
    let fullname: String
    let email: String
    let userType: UserType
    var location: CLLocation?
    
    init(data: [String: Any]) {
        self.id = data["uid"] as? String ?? ""
        self.fullname = data["fullname"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.userType = .init(rawValue: data["accountType"] as? String ?? "") ?? .RIDER
    }
    
    func getDriverPointAnnotation() -> DriverPointAnnotation? {
        guard let location = location else { return nil }
        let annotation = DriverPointAnnotation(id: self.id, coordinate: location.coordinate)
        return annotation
    }
}
