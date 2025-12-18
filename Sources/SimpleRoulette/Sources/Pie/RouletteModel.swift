//
//  RouletteModel.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/09/30.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation
import SwiftUI
import Observation

/// ``RouletteModel`` is a model that interacts with ``View`` and manages state of Roulette.
@Observable
@MainActor
public final class RouletteModel {
    public var parts: [PartData] = []
    public var state: RouletteState = .start

    private var whenToStopHandler: (() -> Void)?
    private let worker: RouletteWorker = .init()

    /// Callback that is invoked when the roulette stops and a part is selected.
    public var onDecide: ((PartData?) -> Void)?

    public init(parts: [PartData]) {
        self.parts = parts
        self.parts.calculateAngles()
    }

    public func updateParts(_ parts: [PartData]) {
        self.parts = parts
        self.parts.calculateAngles()
    }

    /// Method that starts Roulette!
    ///
    /// - Parameters:
    ///     - speed: You can set arbitrary speed with ``RouletteSpeed``
    ///     By default, ``RouletteSpeed/random()`` is set.
    ///     - isContinue: if this value is `true`, We recognize that current situation is `pause` and will resume the rotation.
    ///     If you called ``RouletteModel/pause()``, please pass `true` to this parameter.
    ///     Default value is `false`.
    ///     - automaticallyStopAfter: this value should be set to the duration (seconds) we want Roulette running.
    ///     Default value is `nil` which means it will not automatically stop unless calling ``RouletteModel/stop()``
    public func start(
        speed _speed: RouletteSpeed = .random(),
        isContinue: Bool = false,
        automaticallyStopAfter: Double? = nil
    ) {
        assert(!(isContinue && automaticallyStopAfter != nil))
        if state.isAnimating {
            return
        }
        onDecide?(nil)
        if case let RouletteState.pause(angle, speed) = state, isContinue {
            startFromCheckPoint(angle: angle, speed: speed)
        } else {
            startCompletely(speed: _speed, automaticallyStopAfter: automaticallyStopAfter)
        }
    }

    private func startCompletely(
        speed: RouletteSpeed,
        automaticallyStopAfter: Double?
    ) {
        state = .run(angle: .zero, speed: speed)
        worker.start(speed: speed, automaticallyStopAfter: automaticallyStopAfter) { [weak self] degrees in
            guard let self else { return }
            if case RouletteState.run = self.state {
                self.state = .run(angle: .degrees(degrees), speed: speed)
            }
        } onEnd: { [weak self] in
            self?.stop()
        }
    }

    private func startFromCheckPoint(angle: Angle, speed: RouletteSpeed) {
        state = .run(angle: angle, speed: speed)
        worker.start(speed: speed, from: angle.degrees, automaticallyStopAfter: nil) { [weak self] degrees in
            guard let self else { return }
            if case RouletteState.run = self.state {
                self.state = .run(angle: .degrees(degrees), speed: speed)
            }
        } onEnd: { [weak self] in
            self?.stop()
        }
    }

    /// Method that restarts Roulette.
    public func restart() {
        guard case let RouletteState.pause(angle, speed) = state else {
            return
        }
        startFromCheckPoint(angle: angle, speed: speed)
    }

    /// Method that pauses Roulette.
    public func pause() {
        if !state.isAnimating {
            return
        }
        guard case let RouletteState.run(angle, speed) = state else {
            return
        }
        state = .pause(angle: angle, speed: speed)
        whenToStopHandler = nil
        worker.pause()
    }

    /// Method that stops Roulette.
    public func stop() {
        if !state.isAnimating {
            return
        }
        guard case let RouletteState.run(angle, _) = state else {
            return
        }
        worker.stop()
        var degrees = angle.degrees

        degrees = degrees.truncatingRemainder(dividingBy: 360)

        for part in parts {
            let start = part.startAngle.degrees + degrees
            let end = part.endAngle.degrees + degrees

            // Angle of ▼
            let stopDegree: Double = 270 + 360 * Double(Int(start) / 360)

            if start <= stopDegree && end >= stopDegree {
                state = .stop(location: part, angle: angle)
                onDecide?(part)
                return
            }
        }
    }
}

