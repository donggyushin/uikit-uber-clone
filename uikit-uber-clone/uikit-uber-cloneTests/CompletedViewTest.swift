//
//  CompletedViewTest.swift
//  uikit-uber-cloneTests
//
//  Created by 신동규 on 2022/01/04.
//

import XCTest
@testable import uikit_uber_clone

class CompletedViewTest: XCTestCase {
    let trip: Trip = .init(passengerId: "1", data: [:])
    lazy var completedView = DIView.resolve(test: true).completedViewFactory(trip)
    
    func testArrived() {
        completedView.viewModel.arrivedButtonTapped()
        
        let waitingForServerResponse: XCTestExpectation = .init(description: "waitingForServerResponse")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            waitingForServerResponse.fulfill()
        }
        wait(for: [waitingForServerResponse], timeout: 10)
        
        XCTAssertNil(completedView.viewModel.error)
    }
}
