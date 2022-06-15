//
//  RoulettePartSwiftUIView.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/10/09.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation
import SwiftUI

struct RoulettePart: Shape {

    private let bezier: UIBezierPath
    init(
        data: PartData,
        center: CGPoint,
        radius: Double
    ) {
        self.data = data
        self.center = center
        self.radius = radius

        self.bezier = {
            let path = UIBezierPath()
            path.move(to: center)
            let x1 = center.x + cos(data.startAngle.radians)
            let y1 = center.y + sin(data.endAngle.radians)
            path.addLine(to: CGPoint(x: x1, y: y1))
            let x2 = center.x + cos(data.endAngle.radians)
            let y2 = center.y + sin(data.endAngle.radians)
            let midX = (x1 + x2) / 2
            let midY = (y1 + y2) / 2
            path.addQuadCurve(
                to: CGPoint(
                    x: x2,
                    y: y2
                ),
                controlPoint: CGPoint(
                    x: midX,
                    y: midY
                )
            )
            return path
        }()

    }


    // MARK: Property
    var data: PartData
    var center: CGPoint
    var radius: Double


    func path(in rect: CGRect) -> Path {
        let path = Path(bezier.cgPath)
        let multiplier = min(rect.width, rect.height)
        let transform = CGAffineTransform(
            scaleX: multiplier,
            y: multiplier
        )
        return path.applying(transform)
    }

    var xPadding: Double {
        let mid = (data.startAngle + data.endAngle) / 2
        return center.x + radius * cos(mid.radians)
    }

    var yPadding: Double {
        let mid = (data.startAngle + data.endAngle) / 2
        return center.x + radius * sin(mid.radians)
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
        }
    }
}
