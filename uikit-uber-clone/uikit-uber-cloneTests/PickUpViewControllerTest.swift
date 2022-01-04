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
        
    }
    
}
