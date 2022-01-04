//
//  DIView.swift
//  uikit-uber-clone
//
//  Created by 신동규 on 2022/01/04.
//

import MapKit

struct DIView {
    let rideRequestViewFactory: (MKPlacemark) -> RideRequestView
}

extension DIView {
    static func resolve(test: Bool = false) -> DIView {
        
        let diViewModel = DIViewModel.resolve(test: test)
        
        let rideRequestViewFactory: (MKPlacemark) -> RideRequestView = { placemark in
            return .init(viewModel: diViewModel.rideRequestViewModelFactory(placemark))
        }
        
        return .init(rideRequestViewFactory: rideRequestViewFactory)
    }
}
