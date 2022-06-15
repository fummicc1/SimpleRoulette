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
            Path { path in
                path.move(to: center)
                path.addArc(
                    center: center,
                    radius: radius,
                    startAngle: data.startAngle,
                    endAngle: data.endAngle,
                    clockwise: false
                )
                path.closeSubpath()
            }
            .stroke(lineWidth: data.lineWidth)
            .fill(data.strokeColor)
            .background(data.fillColor)
            data.content.view
        }
    }
}
