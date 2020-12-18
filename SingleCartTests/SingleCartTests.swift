//
//  SingleCartTests.swift
//  SingleCartTests
//
//  Created by apple on 04/07/20.
//  Copyright © 2020 apple. All rights reserved.
//

import XCTest
@testable import SingleCart

class LoginTest {
    func setUPLogin(){
        
    }
}

class SingleCartTests: XCTestCase {
    
var vcLogin: ViewController!

    override func setUp() {
        super.setUp()
        vcLogin = Login
        _ = vcLogin.view
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }


    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func setUpLogin(){
        vcLogin.mobileNumberTextField.text = "989509594"
        vcLogin.passwordTextField.text = "123456"
        vcLogin.loginButton.sendActions(for: .touchUpInside)
    }
}
