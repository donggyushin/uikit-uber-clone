//
//  SplashViewControllerTest.swift
//  uikit-uber-cloneTests
//
//  Created by 신동규 on 2022/01/03.
//

import Foundation
import XCTest
@testable import uikit_uber_clone

class SplashViewControllerTest: XCTestCase {
    let splashViewController = DIViewController.resolve(test: true).splashViewControllerFactory().viewControllers.compactMap({ $0 as? SplashViewController }).first
    
    func testNavigation() {
        splashViewController?.viewDidLoad()
        let expectation: XCTestExpectation = .init(description: "waiting for navigation completed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
}
