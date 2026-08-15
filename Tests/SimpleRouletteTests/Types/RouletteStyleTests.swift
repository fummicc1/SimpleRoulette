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

    @Test("Default style places labels near the rim, following the wedge, with a hub")
    func defaultStyle() {
        let style = RouletteStyle.default

        #expect(style.labelOrientation == .radial)
        #expect(style.labelPosition > 0.5)
        #expect(style.innerRadiusRatio > 0)
    }

    @Test("Pie style reproduces the 1.x look")
    func pieStyle() {
        let style = RouletteStyle.pie

        #expect(style.labelOrientation == .tangential)
        #expect(abs(style.labelPosition - 0.5) < accuracy)
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
