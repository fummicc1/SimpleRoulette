//
//  RoulettePartSwiftUIView.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/10/09.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation
import SwiftUI

struct PartView: View {
    
    var radius: Double
    var center: CGPoint
    var part: RoulettePartType
    var currentAngle: Angle

    var body: some View {
        ZStack(alignment: .center) {
            RouletteShape(
                radius: radius,
                center: center,
                part: part
            )
            .fill(
                fillContent: part.fillColor,
                strokeContent: part.strokeColor
            )
            content()
            .offset(
                CGSize(
                    width: { () -> CGFloat in
                        let mean = (part.startRadian + part.endRadian) / 2
                        let x: CGFloat = radius * 2/3 * CGFloat(cos(mean))
                        return x
                    }(),
                    height: { () -> CGFloat in
                        let mean = (part.startRadian + part.endRadian) / 2
                        let y: CGFloat = radius * 2/3 * CGFloat(sin(mean))
                        return y
                    }()
                )
            )
            .lineLimit(nil)
        }
        .frame(width: radius * 2, height: radius * 2)
    }

    private func content() -> AnyView {
        if let content = part.content {
            return content()
        } else {
            return AnyView(Text(part.label))
        }
    }
}
