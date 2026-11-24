import Testing
import SwiftUI
@testable import SimpleRoulette

@Suite("RouletteModel stop(at:) with a running worker")
@MainActor
struct RouletteModelStopIntegrationTests {

    private static let pollInterval = Duration.milliseconds(5)
    private static let pollTimeout = Duration.seconds(1)
    private static let settleTime = Duration.milliseconds(100)

    private func wait(until condition: () -> Bool) async throws {
        let deadline = ContinuousClock.now + Self.pollTimeout
        while !condition() {
            try #require(ContinuousClock.now < deadline, "Timed out waiting for the roulette")
            try await Task.sleep(for: Self.pollInterval)
        }
    }

    private func isRotating(_ model: RouletteModel) -> Bool {
        (model.state.angle?.degrees ?? 0) > 0
    }

    @Test("The stopped worker does not overwrite the state")
    func stoppedWorkerLeavesState() async throws {
        let model = RouletteModel(parts: Fixture.quarters)
        model.start(speed: .slow)
        try await wait { isRotating(model) }

        model.stop(at: .degrees(90), additionalTurns: 1)
        let stopped = model.state
        try await Task.sleep(for: Self.settleTime)

        #expect(model.state == stopped)
        #expect(model.decidedPart?.index == 1)
    }

    @Test("Stops again after an automatic stop")
    func afterAutomaticStop() async throws {
        let model = RouletteModel(parts: Fixture.quarters)
        model.start(speed: .slow, automaticallyStopAfter: 0.05)
        try await wait { model.decidedPart != nil }
        let automaticAngle = try #require(model.state.angle)

        model.stop(at: .degrees(135))

        #expect(model.decidedPart?.index == 1)
        #expect(try #require(model.state.angle).degrees >= automaticAngle.degrees)
    }

    @Test("Starts again right after stopping")
    func startRightAfterStop() async throws {
        let model = RouletteModel(parts: Fixture.quarters)
        model.start(speed: .slow)
        try await wait { isRotating(model) }

        model.stop(at: .degrees(90))
        model.start(speed: .slow)
        try await Task.sleep(for: Self.settleTime)

        withKnownIssue("The previous rotation's end handler stops the new rotation") {
            #expect(model.state.isAnimating)
        }
        model.stop()
    }
}
