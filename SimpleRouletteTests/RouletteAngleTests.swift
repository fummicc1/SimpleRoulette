//
//  RouletteAngleTests.swift
//  SimpleRouletteTests
//
//  Created by Fumiya Tanaka on 2020/06/02.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import XCTest
@testable import SimpleRoulette

class RouletteAngleTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testAngle_BiggerThan2pi() throws {
        let radian: Double = Double.pi * 4
        let angle = RouletteAngle.init(degree: radian)
        XCTAssertEqual(angle.value, Double.pi * -1/2)
        XCTAssertTrue(angle.value.degree() <= Double.pi * 2, "Degree is too big.")
    }
    
    
}
