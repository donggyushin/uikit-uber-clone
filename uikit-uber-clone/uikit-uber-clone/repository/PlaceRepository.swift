//
//  PlaceRepository.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import MapKit

protocol PlaceRepository {
    func searchPlaces(query: String, region: MKCoordinateRegion, completion: @escaping ([MKPlacemark]) -> Void)
}
