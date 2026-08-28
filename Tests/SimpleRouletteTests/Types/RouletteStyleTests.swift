//
//  RouletteStyleTests.swift
//
//
//  Created by Fumiya Tanaka on 2026/08/15.
//

import Testing
import SwiftUI
@testable import SimpleRoulette

@Suite("RouletteStyle Tests")
struct RouletteStyleTests {

    private let accuracy = 0.0001

    @Test("Default style lays the wheel out like a real roulette")
    func defaultStyle() {
        let style = RouletteStyle.default

        // Faithful radial layout, labels anchored near the rim, hub in the middle.
        #expect(style.labelOrientation == .radial)
        #expect(style.labelPosition == nil)
        #expect(style.resolvedLabelPosition > 0.9)
        #expect(style.innerRadiusRatio > 0)
    }

    @Test("Anchor radius resolves per orientation when unspecified")
    func labelPositionResolution() {
        #expect(RouletteStyle(labelOrientation: .radial).resolvedLabelPosition == 0.95)
        #expect(RouletteStyle(labelOrientation: .radialUpright).resolvedLabelPosition == 0.95)
        #expect(RouletteStyle(labelOrientation: .tangential).resolvedLabelPosition == 0.5)
        #expect(RouletteStyle(labelOrientation: .fixed).resolvedLabelPosition == 0.5)

        // An explicit value always wins.
        #expect(RouletteStyle(labelPosition: 0.8, labelOrientation: .radial).resolvedLabelPosition == 0.8)
        #expect(RouletteStyle(labelPosition: 0.8, labelOrientation: .fixed).resolvedLabelPosition == 0.8)
    }

    @Test("Only radialUpright's left half swaps the anchored end of the band")
    func flippedUpright() {
        // The flip tracks exactly where radialUpright's rotation flips.
        #expect(RouletteLabelOrientation.radialUpright.isFlippedUpright(midAngle: .degrees(180)))
        #expect(!RouletteLabelOrientation.radialUpright.isFlippedUpright(midAngle: .degrees(0)))
        #expect(!RouletteLabelOrientation.radialUpright.isFlippedUpright(midAngle: .degrees(90)))

        // No other orientation ever flips.
        for orientation in [RouletteLabelOrientation.radial, .tangential, .fixed] {
            #expect(!orientation.isFlippedUpright(midAngle: .degrees(180)))
        }
    }

    @Test("Every orientation stays selectable alongside the default")
    func orientationsRemainAvailable() {
        for orientation in [
            RouletteLabelOrientation.radial,
            .radialUpright,
            .tangential,
            .fixed
        ] {
            let style = RouletteStyle(labelOrientation: orientation)
            #expect(style.labelOrientation == orientation)
        }
    }

    @Test("Pie style reproduces the 1.x look")
    func pieStyle() {
        let style = RouletteStyle.pie

        #expect(style.labelOrientation == .tangential)
        #expect(style.labelPosition == 0.5)
        #expect(abs(style.resolvedLabelPosition - 0.5) < accuracy)
        #expect(style.innerRadiusRatio == 0)
    }

    @Test("Ratios are clamped to 0...1")
    func ratioClamping() {
        let tooLarge = RouletteStyle(labelPosition: 4, innerRadiusRatio: 2.5)
        #expect(tooLarge.labelPosition == 1)
        #expect(tooLarge.innerRadiusRatio == 1)

        let negative = RouletteStyle(labelPosition: -1, innerRadiusRatio: -0.5)
        #expect(negative.labelPosition == 0)
        #expect(negative.innerRadiusRatio == 0)
    }

    @Test("Radial labels rotate with their wedge")
    func radialRotation() {
        let mid = Angle(degrees: 45)
        let rotation = RouletteLabelOrientation.radial.rotation(midAngle: mid)
        #expect(abs(rotation.degrees - 45) < accuracy)
    }

    @Test("Upright labels are flipped only on the half where text would be inverted")
    func radialUprightRotation() {
        let orientation = RouletteLabelOrientation.radialUpright

        // Right half reads outward already, so it is left alone.
        #expect(abs(orientation.rotation(midAngle: .degrees(45)).degrees - 45) < accuracy)
        #expect(abs(orientation.rotation(midAngle: .degrees(315)).degrees - 315) < accuracy)

        // Left half would be upside down, so it gets a further 180 degrees.
        #expect(abs(orientation.rotation(midAngle: .degrees(135)).degrees - 315) < accuracy)
        #expect(abs(orientation.rotation(midAngle: .degrees(180)).degrees - 360) < accuracy)

        // Boundaries stay unflipped.
        #expect(abs(orientation.rotation(midAngle: .degrees(90)).degrees - 90) < accuracy)
        #expect(abs(orientation.rotation(midAngle: .degrees(270)).degrees - 270) < accuracy)
    }

    @Test("Upright flipping survives angles outside 0..<360")
    func radialUprightWrapping() {
        let orientation = RouletteLabelOrientation.radialUpright

        // 495 wraps to 135, which is on the flipped half.
        #expect(abs(orientation.rotation(midAngle: .degrees(495)).degrees - 675) < accuracy)
        // -225 wraps to 135 as well.
        #expect(abs(orientation.rotation(midAngle: .degrees(-225)).degrees - (-45)) < accuracy)
    }

    @Test("Tangential labels sit perpendicular to the radius")
    func tangentialRotation() {
        let mid = Angle(degrees: 45)
        let rotation = RouletteLabelOrientation.tangential.rotation(midAngle: mid)
        #expect(abs(rotation.degrees - 135) < accuracy)
    }

    @Test("Fixed labels stay upright whatever the wedge angle")
    func fixedRotation() {
        for degrees in stride(from: 0.0, to: 360.0, by: 45.0) {
            let rotation = RouletteLabelOrientation.fixed.rotation(midAngle: .degrees(degrees))
            #expect(rotation.degrees == 0)
        }
    }
}
