import Testing
import SwiftUI
@testable import SimpleRoulette

@Suite("RouletteModel stop() Tests")
@MainActor
struct RouletteModelStopRegressionTests {

    @Test("Stops at the current angle while running")
    func whileRunning() {
        let model = RouletteModel(parts: Fixture.quarters)
        model.state = .run(angle: .degrees(45), speed: .normal)

        model.stop()

        #expect(model.state == .stop(location: model.parts[2], angle: .degrees(45)))
    }

    @Test("Keeps the angle beyond a full turn as it is")
    func beyondFullTurn() {
        let model = RouletteModel(parts: Fixture.quarters)
        model.state = .run(angle: .degrees(800), speed: .normal)

        model.stop()

        #expect(model.state == .stop(location: model.parts[2], angle: .degrees(800)))
    }

    @Test("Does nothing unless running")
    func unlessRunning() {
        let model = RouletteModel(parts: Fixture.quarters)
        let idleStates: [RouletteState] = [
            .start,
            .pause(angle: .degrees(100), speed: .normal),
            .stop(location: model.parts[2], angle: .degrees(45))
        ]

        for idleState in idleStates {
            model.state = idleState
            model.stop()
            #expect(model.state == idleState)
        }
    }

    @Test("A part wider than 270 degrees wins when it is under the pointer")
    func widePartUnderPointer() {
        let model = RouletteModel(parts: Fixture.wide)
        model.state = .run(angle: .degrees(340), speed: .normal)

        model.stop()

        #expect(model.state == .stop(location: model.parts[0], angle: .degrees(340)))
    }

    @Test("Stays in the run state when the pointer is over a gap")
    func pointerOverGap() {
        let model = RouletteModel(parts: Fixture.gapped)
        let running = RouletteState.run(angle: .zero, speed: .normal)
        model.state = running

        model.stop()

        #expect(model.state == running)
    }
}
