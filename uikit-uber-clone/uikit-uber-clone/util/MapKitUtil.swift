//
//  MapKitUtil.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/27.
//

import MapKit

class MapKitUtil {
    static let shared = MapKitUtil()
    
    func generateOverlays(placemark: MKPlacemark, completion: @escaping (Result<[MKPolyline], Error>) -> Void) {
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = .init(placemark: placemark)
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let error = error {
                return completion(.failure(error))
            } else if let routes = response?.routes {
                return completion(.success(routes.map({ $0.polyline })))
            }
        }
    }
}
