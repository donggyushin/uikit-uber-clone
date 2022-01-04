//
//  PickUpViewControllerTest.swift
//  uikit-uber-cloneTests
//
//  Created by 신동규 on 2022/01/04.
//

import XCTest
@testable import uikit_uber_clone

class PickUpViewControllerTest: XCTestCase {
    
    let trip: Trip = .init(passengerId: "1", data: [:])
    
    lazy var viewController = DIViewController.resolve(test: true).pickupViewControllerFactory(trip)
    
    func testAcceptTrip() {
        viewController.viewDidLoad()
        viewController.viewModel.acceptTrip()
        
        let waitingForAcceptingTrip: XCTestExpectation = .init(description: "waitingForAcceptingTrip")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            waitingForAcceptingTrip.fulfill()
        }
        wait(for: [waitingForAcceptingTrip], timeout: 10)
        XCTAssertTrue(viewController.viewModel.success)
    }
    
}
