//
//  RouletteInternalView.swift
//  
//
//  Created by Fumiya Tanaka on 2023/02/14.
//

import Foundation
import SwiftUI

public struct RouletteInternalView: View {

    @EnvironmentObject var model: RouletteModel

    @State private var currentAngle: Angle = .init()
    @State private var radius: CGFloat = 0
    @State private var center: CGPoint = .zero
    @State private var length: CGFloat
    @State private var startsAnimate: Bool = false

    let stopView: AnyView

    public var body: some View {
        VStack {
            stopView
            GeometryReader { geometry in
                content
                    .aspectRatio(1, contentMode: .fit)
                    .rotationEffect(currentAngle)
                    .onAppear(perform: {
                        let midX = geometry.frame(in: .local).midX
                        let midY = geometry.frame(in: .local).midY
                        let centerValue = min(midX, midY)
                        center = CGPoint(
                            x: centerValue,
                            y: centerValue
                        )
                        radius = centerValue
                    })
                    .onReceive(model.$state, perform: { state in
                        guard let angle = state.angle else {
                            return
                        }
                        self.currentAngle = angle
                    })
            }
            .frame(width: length, height: length)
        }
    }

    private var content: some View {
        ZStack {
            ForEach(model.parts, id: \.self) { (part) -> ZStack in
                ZStack {
                    RoulettePart(
                        data: part,
                        center: center,
                        radius: radius
                    )
                }
            }
            ForEach(model.parts, id: \.self) { (part) -> ZStack in
                let angle = ((part.endAngle + part.startAngle) / 2) + Angle(degrees: 90)
                ZStack {
                    part.content.view
                        .rotationEffect(angle)
                        .offset(
                            CGSize(
                                width: { () -> Double in
                                    let mean = (part.startAngle + part.endAngle) / 2
                                    return radius * 0.5 * cos(mean.radians)
                                }(),
                                height: { () -> Double in
                                    let mean = (part.startAngle + part.endAngle) / 2
                                    return radius * 0.5 * sin(mean.radians)
                                }()
                            )
                        )
                }
            }
        }
    }

    /// Initialization
    ///
    /// - Note: Please note that ``RouletteView`` is not rectangle but **square** (same width and height).
    ///
    /// - Parameters:
    ///     - stopView: If you want to customize `stopView`, please pass `AnyView` to this parameter.
    ///     Default value is nil which means `Image(systemName: "arrowtriangle.down.fill")`
    ///     is used as a `stopView`.
    ///     - length: set the frame length of ``RouletteView`` (square).
    ///     Default value is `320`.
    public init(
        stopView: AnyView? = nil,
        length: CGFloat = 320
    ) {
        self._length = State(initialValue: length)
        if let stopView = stopView {
            self.stopView = stopView
        } else {
            self.stopView = AnyView(
                Image(systemName: "arrowtriangle.down.fill")
                    .font(.system(.title))
                    .fixedSize()
            )
        }
    }
}
