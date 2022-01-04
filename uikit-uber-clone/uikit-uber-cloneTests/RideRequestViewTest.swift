//
//  RideRequestViewTest.swift
//  uikit-uber-cloneTests
//
//  Created by 신동규 on 2022/01/04.
//

import XCTest
@testable import uikit_uber_clone
import MapKit
class RideRequestViewTest: XCTestCase {
    
    let placemark: MKPlacemark = .init(coordinate: .init(latitude: .init(1), longitude: .init(1)))
    
    lazy var view = DIView.resolve(test: true).rideRequestViewFactory(placemark)
    
    func testRequestTrip() {
        view.viewModel.confirmButtonTapped(mapView: .init())
        let waitingForServerResponse: XCTestExpectation = .init(description: "waitingForServerResponse")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            waitingForServerResponse.fulfill()
        }
        wait(for: [waitingForServerResponse], timeout: 10)
        XCTAssertTrue(view.viewModel.requestSuccess)
    }
}
