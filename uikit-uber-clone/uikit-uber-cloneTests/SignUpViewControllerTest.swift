//
//  SignUpViewControllerTest.swift
//  uikit-uber-cloneTests
//
//  Created by 신동규 on 2022/01/04.
//

import XCTest
@testable import uikit_uber_clone

class SignUpViewControllerTest: XCTestCase {
    let signUpViewController = DIViewController.resolve(test: true).signUpViewControllerFactory()
    
    func testSignUpFail() {
        signUpViewController.signUpViewModel.signUp(email: "", password: "", fullName: "", userType: .RIDER)
        
        let waitingForSignUp: XCTestExpectation = .init(description: "waitingForSignUp")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            waitingForSignUp.fulfill()
        }
        
        wait(for: [waitingForSignUp], timeout: 10)
        XCTAssertEqual("정보를 모두 입력해주세요", signUpViewController.signUpViewModel.error?.localizedDescription)
    }
}
