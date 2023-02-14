//
//  RouletteViewSwiftUI.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/09/30.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import SwiftUI

/// ``RouletteView`` is a `View` in `SwiftUI` framework.
///
/// ``RouletteView`` contains multiple ``PartData`` which has each element of Roulette.
///
/// You can use it like the following way.
///
///
///       struct SelectionView: View {
///             var body: some View {
///                 RouletteView(
///                     model: RouletteModel(
///                         parts: [
///                             PartData(content: .label("Swift"), area: .flex(2)),
///                             PartData(content: .label("Dart"), area: .flex(1)),
///                         ]
///                     )
///                 )
///                 .startOnAppear()
///             }
///       }
///
public struct RouletteView: View {
    
    @StateObject var model: RouletteModel

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
                ZStack {
                    part.content.view
                        .offset(
                            CGSize(
                                width: { () -> Double in
                                    let mean = (part.startAngle + part.endAngle) / 2
                                    return radius * 1/2 * cos(mean.radians)
                                }(),
                                height: { () -> Double in
                                    let mean = (part.startAngle + part.endAngle) / 2
                                    return radius * 1/2 * sin(mean.radians)
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
    ///     - model: please pass ``RouletteModel`` instance
    ///     which manages many stufffs of ``RouletteView``.
    ///     - stopView: If you want to customize `stopView`, please pass `AnyView` to this parameter.
    ///     Default value is nil which means `Image(systemName: "arrowtriangle.down.fill")`
    ///     is used as a `stopView`.
    ///     - length: set the frame length of ``RouletteView`` (square).
    ///     Default value is `320`.
    public init(
        model: RouletteModel,
        stopView: AnyView? = nil,
        length: CGFloat = 320
    ) {
        self._length = State(initialValue: length)
        self._model = StateObject(wrappedValue: model)
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

    /// Initialization
    ///
    /// - Note: Please note that ``RouletteView`` is not rectangle but **square** (same width and height).
    ///
    /// - Parameters:
    ///     - parts: please pass `Array` of ``PartData`` instance
    ///     which corresponds to each element inside Roulette.
    ///     - stopView: If you want to customize `stopView`, please pass `AnyView` to this parameter.
    ///     Default value is nil which means `Image(systemName: "arrowtriangle.down.fill")`
    ///     is used as a `stopView`.
    ///     - length: set the frame length of ``RouletteView`` (square).
    ///     Default value is `320`.
    public init(
        parts: [PartData],
        stopView: AnyView? = nil,
        length: CGFloat = 320
    ) {
        let model = RouletteModel(parts: parts)
        self.init(model: model, stopView: stopView, length: length)
    }

    /// Method that starts Roulette!
    ///
    /// This method is kind of syntax suger of ``RouletteModel/start(speed:isConitnue:automaticallyStopAfter:)``.
    ///
    /// - Parameters:
    ///     - speed: You can set arbitrary speed with ``RouletteSpeed``
    ///     By default, ``RouletteSpeed/random()`` is set.
    ///     - isContinue: if this value is `true`, We recognize that current situation is `pause` and will resume the rotation.
    ///     If you called ``RouletteModel/pause()``, please pass `true` to this parameter.
    ///     Default value is `false`.
    ///     - automaticallyStopAfter: this value should be set to the duration (seconds) we want Roulette running.
    ///     Default value is `nil` which means it will not automatically stop unless calling ``RouletteView/stop()``
    public func startOnAppear(
        speed: RouletteSpeed = .random(),
        isConitnue: Bool = false,
        automaticallyStopAfter: Double? = nil
    ) -> some View {
        return onAppear {
            model.start(
                speed: speed,
                isConitnue: isConitnue,
                automaticallyStopAfter: automaticallyStopAfter
            )
        }
    }

    /// Method that stops Roulette.
    ///
    /// This method is kind of syntax suger of ``RouletteModel/stop()``.
    /// - Note: This method does not immediately stop Roulette.
    /// a delay which makes us feel more realistic Roulette happens.
    public func stop() {
        model.stop()
    }
}
