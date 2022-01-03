//
//  PlaceRepositoryTest.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2022/01/03.
//
import MapKit

class PlaceRepositoryTest: PlaceRepository {
    func searchPlaces(query: String, region: MKCoordinateRegion, completion: @escaping ([MKPlacemark]) -> Void) {
        completion([])
    }
    
    static let shared = PlaceRepositoryTest()
}
