//
//  LoginViewControllerTest.swift
//  uikit-uber-cloneTests
//
//  Created by 신동규 on 2022/01/04.
//

import XCTest
@testable import uikit_uber_clone

class LoginViewControllerTest: XCTestCase {
    let loginViewController = DIViewController.resolve(test: true).loginViewControllerFactory()
    
    func testLoginFail() {
        loginViewController.viewDidLoad()
        loginViewController.loginViewModel.login(email: "1", password: "1")
        
        let waitingForLoginSuccess: XCTestExpectation = .init(description: "waitingForLoginSuccess")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            waitingForLoginSuccess.fulfill()
        }
        wait(for: [waitingForLoginSuccess], timeout: 10)
        XCTAssertNotNil(loginViewController.loginViewModel.error)
    }
}
