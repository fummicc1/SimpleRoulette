//
//  OperatorTests.swift
//  SimpleRouletteTests
//
//  Created by Fumiya Tanaka on 2020/06/02.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import XCTest
@testable import SimpleRoulette

class OperatorTests: XCTestCase {

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

    func testOperator() {
        var r = Double(360).radian().accurate()
        let l = Double(0).radian().accurate()
        XCTAssertTrue(r ~=~ l)
    }
}
