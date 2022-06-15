//
//  RoulettePartSwiftUIView.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/10/09.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation
import SwiftUI

struct RoulettePart: View {

    init(
        index: Int,
        radians: Double,
        initialRadians: Double,
        radius: Double,
        center: CGPoint,
        label: String? = nil,
        content: (() -> AnyView)? = nil,
        delegate: RoulettePartHugeDelegate?,
        fillColor: Color,
        strokeColor: Color,
        lineWidth: Double = 2
    ) {
        assert(label != nil || content != nil)
        self.index = index
        self.radians = radians
        self.radius = radius
        self.center = center
        self.label = label
        self.content = content
        self.delegate = delegate
        self.fillColor = fillColor
        self.strokeColor = strokeColor
        self.lineWidth = lineWidth

        _currentAngle = .init(initialValue: .radians(initialRadians))
    }


    // MARK: Property
    /// position. Begin with 0.
    var index: Int

    var radians: Double
    var radius: Double
    var center: CGPoint

    var label: String?
    var content: (() -> AnyView)?

    weak var delegate: RoulettePartHugeDelegate?

    // MARK: Style
    var fillColor: Color
    var strokeColor: Color
    var lineWidth: Double

    // MARK: State
    @State private var currentAngle: Angle

    var body: some View {
        Path { path in
            path.move(to: center)
            path.addArc(
                center: center,
                radius: radius,
                startAngle: currentAngle,
                endAngle: currentAngle + Angle.radians(radians),
                clockwise: false
            )
            path.closeSubpath()
        }
        .stroke(lineWidth: lineWidth)
        .fill(strokeColor)
        .background(fillColor)
    }
}
