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
        Angle(radians: part.startRadian)
    }
    var endAngle: Angle {
        Angle(radians: part.endRadian)
    }
    var radius: CGFloat
    var center: CGPoint
    var fillColor: Color {
        part.fillColor
    }
    var strokeColor: Color {
        part.strokeColor
    }
    
    var part: RoulettePartType
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: center)
            path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false, transform: .identity)
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

struct RouletteShape_Previews: PreviewProvider {
    static var previews: some View {
        RouletteShape(radius: 96, center: .init(x: 100, y: 100), part: Roulette.HugePart(name: "Test A", huge: .normal, delegate: nil, index: 0, fillColor: .red, strokeColor: .blue))
    }
}
