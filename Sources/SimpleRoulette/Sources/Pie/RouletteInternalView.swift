//
//  RouletteInternalView.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2023/02/14.
//

import Foundation
import SwiftUI

public struct RouletteInternalView<StopView: View>: View {

    var model: RouletteModel

    @Environment(\.rouletteStyle) private var style

    @State private var currentAngle: Angle = .init()
    @State private var radius: CGFloat = 0
    @State private var center: CGPoint = .zero
    @State private var length: CGFloat
    @State private var startsAnimate: Bool = false

    let stopView: StopView

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
                    .onChange(of: model.state) { _, newState in
                        guard let angle = newState.angle else {
                            return
                        }
                        self.currentAngle = angle
                    }
            }
            .frame(width: length, height: length)
        }
    }

    private var content: some View {
        ZStack {
            ForEach(model.parts) { part in
                RoulettePart(
                    data: part,
                    center: center,
                    radius: radius,
                    innerRadius: radius * style.innerRadiusRatio
                )
            }
            ForEach(model.parts) { part in
                label(for: part)
            }
        }
    }

    /// Distance kept between the hub and the inner end of a radial label band.
    private static let labelHubInset: CGFloat = 4

    @ViewBuilder
    private func label(for part: PartData) -> some View {
        let mid = (part.startAngle + part.endAngle) / 2
        let rotation = style.labelOrientation.rotation(midAngle: mid)
        if style.labelOrientation.isRadial {
            // The label lives in a band spanning hub to anchor radius, rotated as
            // one piece and anchored to its outer end, so every label's outer end
            // lands on the same circle regardless of the label's own width.
            let hubEdge = radius * style.innerRadiusRatio + Self.labelHubInset
            let rimEdge = radius * style.resolvedLabelPosition
            let span = max(rimEdge - hubEdge, 0)
            let bandCenter = (hubEdge + rimEdge) / 2
            let flipped = style.labelOrientation.isFlippedUpright(midAngle: mid)
            part.content.view
                .frame(width: span, alignment: flipped ? .leading : .trailing)
                .rotationEffect(rotation)
                .offset(
                    CGSize(
                        width: bandCenter * cos(mid.radians),
                        height: bandCenter * sin(mid.radians)
                    )
                )
        } else {
            let distance = radius * style.resolvedLabelPosition
            part.content.view
                .rotationEffect(rotation)
                .offset(
                    CGSize(
                        width: distance * cos(mid.radians),
                        height: distance * sin(mid.radians)
                    )
                )
        }
    }

    /// Initialization
    ///
    /// - Note: Please note that ``RouletteView`` is not rectangle but **square** (same width and height).
    ///
    /// - Parameters:
    ///     - model: The roulette model to observe.
    ///     - stopView: View displayed as the stop indicator.
    ///     - length: set the frame length of ``RouletteView`` (square).
    ///     Default value is `320`.
    public init(
        model: RouletteModel,
        stopView: StopView,
        length: CGFloat = 320
    ) {
        self.model = model
        self._length = State(initialValue: length)
        self.stopView = stopView
    }
}

extension RouletteInternalView where StopView == Image {
    /// Convenience initializer with default stop view.
    public init(
        model: RouletteModel,
        length: CGFloat = 320
    ) {
        self.init(
            model: model,
            stopView: Image(systemName: "arrowtriangle.down.fill"),
            length: length
        )
    }
}
