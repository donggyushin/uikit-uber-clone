//
//  PlaceRepositoryImpl.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import MapKit

class PlaceRepositoryImpl: PlaceRepository {
    
    static let shared = PlaceRepositoryImpl()
    
    func searchPlaces(query: String, region: MKCoordinateRegion, completion: @escaping ([MKPlacemark]) -> Void) {
        let request = MKLocalSearch.Request()
        request.region = region
        request.naturalLanguageQuery = query
        
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else { return }
            return completion(response.mapItems.map({ $0.placemark }))
        }
    }
}
