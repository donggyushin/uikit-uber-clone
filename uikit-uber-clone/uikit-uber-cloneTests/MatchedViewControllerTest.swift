//
//  MatchedViewControllerTest.swift
//  uikit-uber-cloneTests
//
//  Created by 신동규 on 2022/01/04.
//

import XCTest
@testable import uikit_uber_clone

class MatchedViewControllerTest: XCTestCase {
    let trip: Trip = .init(passengerId: "1", data: [:])
    lazy var viewController = DIViewController.resolve(test: true).matchedViewControllerFactory(trip)
    
    func testCancelTrip() {
        viewController.viewDidLoad()
        viewController.viewModel.cancelButtonTapped()
        let waitingForServer: XCTestExpectation = .init(description: "waitingForServer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            waitingForServer.fulfill()
        }
        wait(for: [waitingForServer], timeout: 10)
        XCTAssertFalse(viewController.viewModel.isLoading)
        XCTAssertNil(viewController.viewModel.error)
    }
}
