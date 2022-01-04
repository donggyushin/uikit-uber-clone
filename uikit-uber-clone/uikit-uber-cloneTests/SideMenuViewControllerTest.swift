//
//  SideMenuViewControllerTest.swift
//  uikit-uber-cloneTests
//
//  Created by 신동규 on 2022/01/04.
//

import XCTest
@testable import uikit_uber_clone

class SideMenuViewControllerTest: XCTestCase {
    let mainViewModel = DIViewModel.resolve(test: true).mainViewModelFactory()
    lazy var sideMenuViewController = DIViewController.resolve(test: true).sideMenuViewController(mainViewModel).viewControllers.first as? SideMenuViewController
    
    func testLogout() {
        guard let sideMenuViewController = sideMenuViewController else { return XCTAssertFalse(true) }
        sideMenuViewController.viewDidLoad()
        sideMenuViewController.viewModel.logoutButtonTapped()
        
        let waitingForLogout: XCTestExpectation = .init(description: "waitingForLogout")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            waitingForLogout.fulfill()
        }
        wait(for: [waitingForLogout], timeout: 10)
        XCTAssertTrue(sideMenuViewController.viewModel.isLogout)
    }
}
