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
        radius: Double
    ) {
        self.data = data
        self.center = center
        self.radius = radius
    }


    // MARK: Property
    var data: PartData
    var center: CGPoint
    var radius: Double


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
        }
    }
}
