//
//  RoulettePartSwiftUIView.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/10/09.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation
import SwiftUI

/// ``RoulettePart`` is a `View` which shows ``PartData``.
struct RoulettePart: View {

    init(
        data: PartData,
        center: CGPoint,
        radius: Double,
        innerRadius: Double = 0
    ) {
        self.data = data
        self.center = center
        self.radius = radius
        self.innerRadius = innerRadius
    }


    // MARK: Property
    var data: PartData
    var center: CGPoint
    var radius: Double
    /// Radius of the hub left empty in the middle. `0` draws a full wedge.
    var innerRadius: Double


    var body: some View {
        ZStack {
            path()
                .fill(data.fillColor)
            path()
                .stroke(data.strokeColor, style: StrokeStyle(
                    lineWidth: data.lineWidth
                ))
        }
    }

    private func path() -> Path {
        Path { path in
            guard innerRadius > 0 else {
                path.move(to: center)
                path.addArc(
                    center: center,
                    radius: radius,
                    startAngle: data.startAngle,
                    endAngle: data.endAngle,
                    clockwise: false,
                    transform: .identity
                )
                path.closeSubpath()
                return
            }
            // Annular sector: out along the rim, back along the hub.
            path.addArc(
                center: center,
                radius: radius,
                startAngle: data.startAngle,
                endAngle: data.endAngle,
                clockwise: false,
                transform: .identity
            )
            path.addArc(
                center: center,
                radius: innerRadius,
                startAngle: data.endAngle,
                endAngle: data.startAngle,
                clockwise: true,
                transform: .identity
            )
            path.closeSubpath()
        }
    }
}
