//
//  PartDataTests.swift
//
//
//  Created by Fumiya Tanaka on 2022/07/24.
//

import Testing
import SwiftUI
@testable import SimpleRoulette

@Suite("PartData Tests")
struct PartDataTests {

    @Test("Equal flex areas distribute degrees equally")
    func equalFlexAreas() {
        var parts = (0..<10).map { index in
            PartData(
                index: index,
                content: Content.label("PartData\(index)"),
                area: .flex(1)
            )
        }
        parts.calculateAngles()

        let expectedDegree: Double = 360.0 / Double(parts.count)
        let allArea = parts.map(\.area)

        for part in parts {
            #expect(part.area.getDegree(all: allArea) == expectedDegree)
        }
    }

    @Test("Fixed degree areas assign correct start and end angles")
    func fixedDegreeAreas() {
        var parts = [
            PartData(index: 0, content: .label("A"), area: .degree(90)),
            PartData(index: 1, content: .label("B"), area: .degree(180)),
            PartData(index: 2, content: .label("C"), area: .degree(90))
        ]

        parts.calculateAngles()

        #expect(parts[0].startAngle.degrees == 0)
        #expect(parts[0].endAngle.degrees == 90)
        #expect(parts[1].startAngle.degrees == 90)
        #expect(parts[1].endAngle.degrees == 270)
        #expect(parts[2].startAngle.degrees == 270)
        #expect(parts[2].endAngle.degrees == 360)
    }

    @Test("Flex areas distribute remaining degrees proportionally")
    func flexAreaDistribution() {
        var parts = [
            PartData(index: 0, content: .label("Fixed"), area: .degree(60)),
            PartData(index: 1, content: .label("Flex1"), area: .flex(1)),
            PartData(index: 2, content: .label("Flex2"), area: .flex(2))
        ]

        parts.calculateAngles()

        // Fixed: 60°, Remaining: 300° distributed as 1:2 ratio
        let accuracy = 0.0001

        #expect(abs(parts[0].startAngle.degrees - 0) < accuracy)
        #expect(abs(parts[0].endAngle.degrees - 60) < accuracy)
        #expect(abs(parts[1].startAngle.degrees - 60) < accuracy)
        #expect(abs(parts[1].endAngle.degrees - 160) < accuracy) // 60 + 100
        #expect(abs(parts[2].startAngle.degrees - 160) < accuracy)
        #expect(abs(parts[2].endAngle.degrees - 360) < accuracy) // 160 + 200
    }
}
