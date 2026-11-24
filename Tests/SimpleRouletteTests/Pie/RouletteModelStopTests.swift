import Testing
import SwiftUI
@testable import SimpleRoulette

@Suite("RouletteModel stop(at:) Tests")
@MainActor
struct RouletteModelStopTests {

    private static let accuracy = 1e-9

    private func expectStopped(
        _ model: RouletteModel,
        index: Int,
        degrees: Double,
        sourceLocation: SourceLocation = #_sourceLocation
    ) {
        guard case let .stop(location, angle) = model.state else {
            Issue.record("Expected .stop but got \(model.state)", sourceLocation: sourceLocation)
            return
        }
        #expect(location.index == index, sourceLocation: sourceLocation)
        #expect(abs(angle.degrees - degrees) < Self.accuracy, sourceLocation: sourceLocation)
    }

    // MARK: - Any state

    @Test("Stops from the start state")
    func fromStart() {
        let model = RouletteModel(parts: Fixture.quarters)

        model.stop(at: .degrees(45))

        expectStopped(model, index: 2, degrees: 45)
        #expect(model.decidedPart?.index == 2)
    }

    @Test("Stops again from the stop state")
    func fromStop() {
        let model = RouletteModel(parts: Fixture.quarters)
        model.state = .stop(location: model.parts[2], angle: .degrees(45))

        model.stop(at: .degrees(135))

        expectStopped(model, index: 1, degrees: 135)
    }

    @Test("Stops from the run state")
    func fromRun() {
        let model = RouletteModel(parts: Fixture.quarters)
        model.state = .run(angle: .degrees(800), speed: .normal)

        model.stop(at: .degrees(90))

        expectStopped(model, index: 1, degrees: 810)
    }

    @Test("Stops from the pause state")
    func fromPause() {
        let model = RouletteModel(parts: Fixture.quarters)
        model.state = .pause(angle: .degrees(100), speed: .normal)

        model.stop(at: .degrees(200))

        expectStopped(model, index: 0, degrees: 200)
    }

    // MARK: - Additional turns

    @Test("Adds full turns before stopping")
    func additionalTurns() {
        let model = RouletteModel(parts: Fixture.quarters)

        model.stop(at: .degrees(90), additionalTurns: 2)

        expectStopped(model, index: 1, degrees: 810)
    }

    @Test("Adds full turns while running")
    func additionalTurnsWhileRunning() {
        let model = RouletteModel(parts: Fixture.quarters)
        model.state = .run(angle: .degrees(800), speed: .normal)

        model.stop(at: .degrees(90), additionalTurns: 1)

        expectStopped(model, index: 1, degrees: 1170)
    }

    @Test("Negative additional turns count as zero")
    func negativeAdditionalTurns() {
        let model = RouletteModel(parts: Fixture.quarters)

        model.stop(at: .degrees(90), additionalTurns: -3)

        expectStopped(model, index: 1, degrees: 90)
    }

    @Test("A huge number of additional turns does not crash")
    func hugeAdditionalTurns() {
        let model = RouletteModel(parts: Fixture.quarters)

        model.stop(at: .degrees(90), additionalTurns: .max)

        #expect(model.decidedPart != nil)
        #expect(model.state.angle?.degrees.isFinite == true)
    }

    // MARK: - Consistency with stop()

    @Test("Decides the same part as stop()", arguments: Array(stride(from: 0.0, to: 360.0, by: 15.0)))
    func sameAsStop(rotation: Double) throws {
        let stopped = RouletteModel(parts: Fixture.quarters)
        stopped.state = .run(angle: .degrees(rotation), speed: .normal)
        stopped.stop()

        let stoppedAt = RouletteModel(parts: Fixture.quarters)
        stoppedAt.stop(at: .degrees(rotation))

        let expected = try #require(stopped.decidedPart)
        let expectedAngle = try #require(stopped.state.angle)
        expectStopped(stoppedAt, index: expected.index, degrees: expectedAngle.degrees)
    }

    @Test("Can start again after stopping")
    func startAfterStop() {
        let model = RouletteModel(parts: Fixture.quarters)
        model.stop(at: .degrees(45))

        model.start(speed: .slow)

        #expect(model.state.isAnimating)
        model.stop()
    }

    // MARK: - No-op inputs

    @Test("Does nothing without parts")
    func emptyParts() {
        let model = RouletteModel(parts: [])

        model.stop(at: .degrees(45))

        #expect(model.state == .start)
    }

    @Test("Keeps running without parts")
    func emptyPartsWhileRunning() {
        let model = RouletteModel(parts: [])
        let running = RouletteState.run(angle: .degrees(100), speed: .normal)
        model.state = running

        model.stop(at: .degrees(45))

        #expect(model.state == running)
    }

    @Test("Does nothing when the pointer would be over a gap")
    func pointerOverGap() {
        let model = RouletteModel(parts: Fixture.gapped)

        model.stop(at: .zero)

        #expect(model.state == .start)
    }

    @Test("Does nothing for non-finite angles", arguments: [Double.nan, Double.infinity])
    func nonFiniteAngle(degrees: Double) {
        let model = RouletteModel(parts: Fixture.quarters)

        model.stop(at: .degrees(degrees))

        #expect(model.state == .start)
    }

    // MARK: - Boundaries

    @Test("Stays in place when the angle equals the current one")
    func sameAngle() {
        let model = RouletteModel(parts: Fixture.quarters)
        model.state = .stop(location: model.parts[2], angle: .degrees(45))

        model.stop(at: .degrees(45))

        expectStopped(model, index: 2, degrees: 45)
    }

    @Test("Moves forward to an angle smaller than the current one")
    func smallerAngle() {
        let model = RouletteModel(parts: Fixture.quarters)
        model.state = .run(angle: .degrees(350), speed: .normal)

        model.stop(at: .degrees(10))

        expectStopped(model, index: 2, degrees: 370)
    }

    @Test("Reads the angle modulo a full turn", arguments: [
        (360.0, 2, 0.0), (725.0, 2, 5.0), (-90.0, 0, 270.0)
    ])
    func moduloFullTurn(degrees: Double, expectedIndex: Int, expectedDegrees: Double) {
        let model = RouletteModel(parts: Fixture.quarters)

        model.stop(at: .degrees(degrees))

        expectStopped(model, index: expectedIndex, degrees: expectedDegrees)
    }

    @Test("Stays in place when the current angle is a multiple of a full turn")
    func currentAngleIsFullTurns() {
        let model = RouletteModel(parts: Fixture.quarters)
        model.state = .run(angle: .degrees(720), speed: .normal)

        model.stop(at: .zero)

        expectStopped(model, index: 2, degrees: 720)
    }

    @Test(
        "Never rotates backwards",
        arguments: [0.0, 10.0, 359.0, 360.0, 800.5, 12345.678],
        [0.0, 90.0, 269.9, 359.0]
    )
    func neverBackwards(current: Double, requested: Double) throws {
        let model = RouletteModel(parts: Fixture.quarters)
        model.state = .run(angle: .degrees(current), speed: .normal)
        let before = try #require(model.state.angle).degrees

        model.stop(at: .degrees(requested))

        let after = try #require(model.state.angle).degrees
        let fullTurn = Angle.fullTurn.degrees
        let travelled = after - before
        #expect(travelled >= 0)
        #expect(travelled < fullTurn)
        let distance = abs(after - requested).truncatingRemainder(dividingBy: fullTurn)
        #expect(min(distance, fullTurn - distance) < 1e-6)
    }
}
