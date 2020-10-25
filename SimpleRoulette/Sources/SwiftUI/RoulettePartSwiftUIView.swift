//
//  RoulettePartSwiftUIView.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/10/09.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation
import SwiftUI

struct RoulettePartSwiftUIView: View {
    
    var radius: CGFloat
    var center: CGPoint
    var part: RoulettePartType
    var currentAngle: Angle
    
    var body: some View {
        ZStack {
            RouletteShape(radius: radius, center: center, part: part)
                .fill(fillContent: part.fillColor.color(), strokeContent: part.strokeColor.color())
            Text(part.name)
                .offset(
                    CGSize(width: { () -> CGFloat in
                        let mean = (part.startRadianAngle + part.endRadianAngle) / 2
                        let x: CGFloat = radius / 1.5 * CGFloat(cos(mean))
                        return x
                    }(), height: { () -> CGFloat in
                        let mean = (part.startRadianAngle + part.endRadianAngle) / 2
                        let y: CGFloat = radius / 1.5 * CGFloat(sin(mean))
                        return y
                    }())
                )
                .lineLimit(nil)
                .frame(width: radius / 1.5, height: radius / 1.5)
        }
        .frame(width: radius * 2, height: radius * 2)
    }
}
