//
//  RouletteStateTests.swift
//  
//
//  Created by Fumiya Tanaka on 2022/07/24.
//

import XCTest
@testable import SimpleRoulette


final class RouletteStateTests: XCTestCase {

    var state: RouletteState!

    func test_initial_run_state() {
        // MARK: Arrange
        state = .run(angle: .zero, speed: .normal)
        // MARK: Assert
        XCTAssertEqual(state.canStart, false)
        XCTAssertEqual(state.isAnimating, true)
        XCTAssertEqual(state.speed, .normal)
        XCTAssertEqual(state.angle, .zero)
    }

    func test_initial_start_state() {
        // MARK: Arrange
        state = .start
        // MARK: Assert
        XCTAssertEqual(state.angle, nil)
        XCTAssertEqual(state.speed, .idle)
        XCTAssertEqual(state.canStart, true)
        XCTAssertEqual(state.isAnimating, false)
    }

    func test_initial_pause_state() {
        // MARK: Arrange
        state = .pause(angle: .zero, speed: .normal)
        // MARK: Assert
        XCTAssertEqual(state.angle, .zero)
        XCTAssertEqual(state.speed, .normal)
        XCTAssertEqual(state.canStart, false)
        XCTAssertEqual(state.isAnimating, false)
    }

    func test_initial_stop_state() {
        // MARK: Arrange
        let stop = PartData(
            index: 0,
            content: .label("Stop"),
            area: .flex(1)
        )
        state = .stop(location: stop, angle: .zero)
        // MARK: Assert
        XCTAssertEqual(state.angle, .zero)
        XCTAssertEqual(state.speed, .idle)
        XCTAssertEqual(state.canStart, true)
        XCTAssertEqual(state.isAnimating, false)
    }
}
