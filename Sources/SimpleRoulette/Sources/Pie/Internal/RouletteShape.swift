//
//  RouletteShape.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/10/01.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import SwiftUI

struct RouletteShape: Shape {
    var startAngle: Angle {
        part.startAngle
    }
    var endAngle: Angle {
        part.endAngle
    }
    var radius: CGFloat
    var center: CGPoint
    var fillColor: Color {
        part.fillColor
    }
    var strokeColor: Color {
        part.strokeColor
    }
    
    var part: PartData
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: center)
            path.addArc(
                center: center,
                radius: radius,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: false,
                transform: .identity
            )
        }
    }
}

extension Shape {
    /// fills and strokes a shape
    public func fill<F:ShapeStyle, S: ShapeStyle>(
        fillContent: F,
        strokeContent: S
    ) -> some View {
        ZStack {
            self.fill(fillContent)
            self.stroke(strokeContent)
        }
    }
}
