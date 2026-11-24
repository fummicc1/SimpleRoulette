import Testing
import SwiftUI
@testable import SimpleRoulette

@Suite("Part lookup Tests")
struct PartLookupTests {

    @Test("The part under the pointer wins", arguments: [
        (45.0, 2), (135.0, 1), (225.0, 0), (315.0, 3)
    ])
    func middleOfPart(rotation: Double, expectedIndex: Int) {
        #expect(Fixture.quarters.part(atRotation: .degrees(rotation))?.index == expectedIndex)
    }

    @Test("Rotations beyond a full turn wrap around")
    func beyondFullTurn() {
        #expect(Fixture.quarters.part(atRotation: .degrees(725))?.index == 2)
    }

    @Test("Negative rotations wrap around")
    func negativeRotation() {
        #expect(Fixture.quarters.part(atRotation: .degrees(-45))?.index == 3)
    }

    @Test("Degree and flex areas can be mixed", arguments: [
        (0.0, 2), (150.0, 1), (250.0, 0)
    ])
    func mixedAreas(rotation: Double, expectedIndex: Int) {
        #expect(Fixture.mixed.part(atRotation: .degrees(rotation))?.index == expectedIndex)
    }

    @Test("A part wider than 270 degrees can win", arguments: [
        (340.0, 0), (300.0, 1)
    ])
    func widePart(rotation: Double, expectedIndex: Int) {
        #expect(Fixture.wide.part(atRotation: .degrees(rotation))?.index == expectedIndex)
    }

    @Test("No part wins when there are no parts")
    func emptyParts() {
        let parts: [PartData] = []
        #expect(parts.part(atRotation: .zero) == nil)
    }

    @Test("No part wins when the pointer is over a gap")
    func pointerOverGap() {
        #expect(Fixture.gapped.part(atRotation: .zero) == nil)
    }

    @Test("A part still wins next to a gap")
    func partNextToGap() {
        #expect(Fixture.gapped.part(atRotation: .degrees(225))?.index == 0)
    }

    @Test("Non-finite rotations never win", arguments: [
        Double.nan, Double.infinity, -Double.infinity
    ])
    func nonFiniteRotation(rotation: Double) {
        #expect(Fixture.quarters.part(atRotation: .degrees(rotation)) == nil)
    }

    @Test("The earlier part wins on a boundary", arguments: [
        (0.0, 2), (90.0, 1), (180.0, 0)
    ])
    func boundary(rotation: Double, expectedIndex: Int) {
        #expect(Fixture.quarters.part(atRotation: .degrees(rotation))?.index == expectedIndex)
    }

    @Test("The first part wins at the start of the wheel")
    func startOfWheel() {
        #expect(Fixture.quarters.part(atRotation: .degrees(270))?.index == 0)
    }

    @Test("One full turn equals no rotation")
    func exactlyOneTurn() {
        #expect(Fixture.quarters.part(atRotation: .degrees(360))?.index == 2)
    }

    @Test("A negative rotation can land on the start of the wheel")
    func negativeBoundary() {
        #expect(Fixture.quarters.part(atRotation: .degrees(-90))?.index == 0)
    }

    @Test("Either side of the start of the wheel", arguments: [
        (269.999, 0), (270.001, 3)
    ])
    func aroundStartOfWheel(rotation: Double, expectedIndex: Int) {
        #expect(Fixture.quarters.part(atRotation: .degrees(rotation))?.index == expectedIndex)
    }

    @Test("Uneven part widths leave no gap", arguments: Array(stride(from: 0.0, to: 360.0, by: 0.5)))
    func unevenWidths(rotation: Double) {
        #expect(Fixture.sevenths.part(atRotation: .degrees(rotation)) != nil)
    }
}
