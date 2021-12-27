//
//  RideRequestViewModel.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2021/12/27.
//

import MapKit
import Combine

class RideRequestViewModel: BaseViewModel {
    @Published var placemark: MKPlacemark
    
    init(placemark: MKPlacemark) {
        self.placemark = placemark
    }
    
    func confirmButtonTapped() {
        
    }
}
