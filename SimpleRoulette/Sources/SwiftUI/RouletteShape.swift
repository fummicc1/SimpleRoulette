//
//  RouletteShape.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/10/01.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import SwiftUI

struct RouletteShape: View {
    var startAngle: Angle
    var endAngle: Angle
    var radius: CGFloat
    var center: CGPoint
    var fillColor: Color
    var strokeColor: Color
    
    var body: some View {
        Path { path in
            path.move(to: center)
            path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false, transform: .identity)
        }
        .fill(fillContent: fillColor, strokeContent: strokeColor)
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

struct RouletteShape_Previews: PreviewProvider {
    static var previews: some View {
        RouletteShape(startAngle: .zero, endAngle: Angle(degrees: 120), radius: 96, center: .init(x: 100, y: 100), fillColor: .blue, strokeColor: .orange)
    }
}
