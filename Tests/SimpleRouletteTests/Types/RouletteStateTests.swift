//
//  RouletteStateTests.swift
//
//
//  Created by Fumiya Tanaka on 2022/07/24.
//

import Testing
@testable import SimpleRoulette

@Suite("RouletteState Tests")
struct RouletteStateTests {

    @Test("Run state properties")
    func runState() {
        let state: RouletteState = .run(angle: .zero, speed: .normal)

        #expect(state.canStart == false)
        #expect(state.isAnimating == true)
        #expect(state.speed == .normal)
        #expect(state.angle == .zero)
    }

    @Test("Start state properties")
    func startState() {
        let state: RouletteState = .start

        #expect(state.angle == nil)
        #expect(state.speed == .idle)
        #expect(state.canStart == true)
        #expect(state.isAnimating == false)
    }

    @Test("Pause state properties")
    func pauseState() {
        let state: RouletteState = .pause(angle: .zero, speed: .normal)

        #expect(state.angle == .zero)
        #expect(state.speed == .normal)
        #expect(state.canStart == false)
        #expect(state.isAnimating == false)
    }

    @Test("Stop state properties")
    func stopState() {
        let stop = PartData(
            index: 0,
            content: .label("Stop"),
            area: .flex(1)
        )
        let state: RouletteState = .stop(location: stop, angle: .zero)

        #expect(state.angle == .zero)
        #expect(state.speed == .idle)
        #expect(state.canStart == true)
        #expect(state.isAnimating == false)
    }
}
