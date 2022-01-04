//
//  MainViewControllerTest.swift
//  uikit-uber-cloneTests
//
//  Created by 신동규 on 2022/01/04.
//

import XCTest
@testable import uikit_uber_clone

class MainViewControllerTest: XCTestCase {
    let mainViewController = DIViewController.resolve(test: true).mainViewControllerFactory()
    
    func testMainViewController() {
        mainViewController.viewDidLoad()
        let expectation: XCTestExpectation = .init(description: "expectation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
}
