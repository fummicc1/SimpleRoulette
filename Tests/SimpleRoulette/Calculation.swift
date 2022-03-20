//
//  Calculation.swift
//  SimpleRouletteTests
//
//  Created by Fumiya Tanaka on 2020/06/03.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import XCTest
@testable import SimpleRoulette


class Calculation: XCTestCase {

    override func setUp() {
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

    func testTruncatingRemainder() {
        let number: Double = Double.pi * 0.5
        let number2: Double = (Double.pi * 0.5).reverse()
        
        XCTAssertEqual(number.truncatingRemainder(dividingBy: Double.pi * 2), number2.truncatingRemainder(dividingBy: Double.pi * 2))
    }
}
