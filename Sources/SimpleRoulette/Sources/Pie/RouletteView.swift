//
//  RouletteView.swift
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
///                     parts: [
///                         PartData(content: .label("Swift"), area: .flex(2)),
///                         PartData(content: .label("Dart"), area: .flex(1)),
///                     ]
///                 )
///                 .startOnAppear()
///             }
///       }
///
public struct RouletteView<StopView: View>: View {

    private let model: RouletteModel

    @State private var length: CGFloat

    let stopView: StopView

    public var body: some View {
        RouletteInternalView(model: model, stopView: stopView, length: length)
    }

    /// Initialization
    ///
    /// - Note: Please note that ``RouletteView`` is not rectangle but **square** (same width and height).
    ///
    /// - Parameters:
    ///     - model: please pass ``RouletteModel`` instance
    ///     which manages many stuffs of ``RouletteView``.
    ///     - stopView: View displayed as the stop indicator.
    ///     - length: set the frame length of ``RouletteView`` (square).
    ///     Default value is `320`.
    public init(
        model: RouletteModel,
        stopView: StopView,
        length: CGFloat = 320
    ) {
        self._length = State(initialValue: length)
        self.model = model
        self.stopView = stopView
    }

    /// Method that starts Roulette!
    ///
    /// This method is kind of syntax sugar of ``RouletteModel/start(speed:isContinue:automaticallyStopAfter:)``.
    ///
    /// - Parameters:
    ///     - speed: You can set arbitrary speed with ``RouletteSpeed``
    ///     By default, ``RouletteSpeed/random()`` is set.
    ///     - isContinue: if this value is `true`, We recognize that current situation is `pause` and will resume the rotation.
    ///     If you called ``RouletteModel/pause()``, please pass `true` to this parameter.
    ///     Default value is `false`.
    ///     - automaticallyStopAfter: this value should be set to the duration (seconds) we want Roulette running.
    ///     Default value is `nil` which means it will not automatically stop unless calling ``RouletteView/stop()``
    ///     - didFinish: a closure that handles after Roulette has been finished.
    ///     Default value is `nil` which means nothing will happen when Roulette stops.
    ///     I recommend you to handle some operation like showing the result on View.
    @ViewBuilder
    public func startOnAppear(
        speed: RouletteSpeed = .random(),
        isContinue: Bool = false,
        automaticallyStopAfter: Double? = nil,
        didFinish: ((PartData) -> Void)? = nil
    ) -> some View {
        self
            .onAppear {
                model.start(
                    speed: speed,
                    isContinue: isContinue,
                    automaticallyStopAfter: automaticallyStopAfter
                )
            }
            .onChange(of: model.state) { _, newState in
                if let didFinish, case .stop(let part, _) = newState {
                    didFinish(part)
                }
            }
    }

    /// Method that stops Roulette.
    ///
    /// This method is kind of syntax sugar of ``RouletteModel/stop()``.
    /// - Note: This method does not immediately stop Roulette.
    /// a delay which makes us feel more realistic Roulette happens.
    public func stop() {
        model.stop()
    }
}

// MARK: - Convenience initializers

extension RouletteView where StopView == Image {
    /// Initialization with default stop view.
    ///
    /// - Note: Please note that ``RouletteView`` is not rectangle but **square** (same width and height).
    ///
    /// - Parameters:
    ///     - model: please pass ``RouletteModel`` instance
    ///     which manages many stuffs of ``RouletteView``.
    ///     - length: set the frame length of ``RouletteView`` (square).
    ///     Default value is `320`.
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

    /// Initialization with parts array.
    ///
    /// - Note: Please note that ``RouletteView`` is not rectangle but **square** (same width and height).
    ///
    /// - Parameters:
    ///     - parts: please pass `Array` of ``PartData`` instance
    ///     which corresponds to each element inside Roulette.
    ///     - length: set the frame length of ``RouletteView`` (square).
    ///     Default value is `320`.
    public init(
        parts: [PartData],
        length: CGFloat = 320
    ) {
        let model = RouletteModel(parts: parts)
        self.init(model: model, length: length)
    }
}

extension RouletteView {
    /// Initialization with parts array and custom stop view.
    ///
    /// - Note: Please note that ``RouletteView`` is not rectangle but **square** (same width and height).
    ///
    /// - Parameters:
    ///     - parts: please pass `Array` of ``PartData`` instance
    ///     which corresponds to each element inside Roulette.
    ///     - stopView: View displayed as the stop indicator.
    ///     - length: set the frame length of ``RouletteView`` (square).
    ///     Default value is `320`.
    public init(
        parts: [PartData],
        stopView: StopView,
        length: CGFloat = 320
    ) {
        let model = RouletteModel(parts: parts)
        self.init(model: model, stopView: stopView, length: length)
    }
}
