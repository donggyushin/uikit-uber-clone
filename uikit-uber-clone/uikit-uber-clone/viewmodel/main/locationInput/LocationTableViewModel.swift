//
//  LocationTableViewModel.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/26.
//

import Combine
import MapKit

class LocationTableViewModel: BaseViewModel {
    @Published var places: [MKPlacemark] = []
    
    private let placeRepository: PlaceRepository
    private let region: MKCoordinateRegion
    
    init(placeRepository: PlaceRepository, region: MKCoordinateRegion) {
        self.placeRepository = placeRepository
        self.region = region
    }
    
    func searchPlaces(query: String) {
        placeRepository.searchPlaces(query: query, region: region) { places in
            self.places = places
        }
    }
}
