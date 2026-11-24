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

    /// The part that was selected when the roulette stopped.
    /// Returns `nil` if the roulette hasn't stopped yet.
    public var decidedPart: PartData? {
        guard case .stop(let part, _) = state else {
            return nil
        }
        return part
    }

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
        guard let part = parts.part(atRotation: angle) else {
            return
        }
        state = .stop(location: part, angle: angle)
    }

    /// Stops the roulette at the given rotation angle.
    ///
    /// `angle` is the rotation of the whole wheel, the same value that
    /// ``RouletteState/stop(location:angle:)`` carries. It is read modulo 360°,
    /// and the wheel only moves forward from its current angle, so the angle
    /// stored in the state can be larger than the one passed in.
    /// The part under the pointer at that angle becomes ``decidedPart``.
    /// On a boundary between two parts, the one that comes first in ``parts`` wins.
    ///
    /// This method can be called in any state. Call it inside `withAnimation`
    /// to animate the wheel to the angle. The state becomes `.stop` as soon as
    /// the animation starts, so use the animation's completion to react
    /// once the wheel has come to rest.
    ///
    /// ```swift
    /// withAnimation(.easeOut(duration: 3)) {
    ///     model.stop(at: .degrees(90), additionalTurns: 2)
    /// } completion: {
    ///     result = model.decidedPart?.content.text ?? ""
    /// }
    /// ```
    ///
    /// Nothing happens when no part is under the pointer at that angle
    /// (``parts`` is empty or leaves a gap there), or when `angle` is not finite.
    ///
    /// - Parameters:
    ///     - angle: The rotation at which the wheel comes to rest.
    ///     - additionalTurns: Full turns to add before the wheel stops.
    ///     Negative values count as `0`. There is no upper limit.
    public func stop(at angle: Angle, additionalTurns: Int = 0) {
        let fullTurn = Angle.fullTurn.degrees
        let current = state.angle?.degrees ?? 0
        let offset = (angle.degrees - current).truncatingRemainder(dividingBy: fullTurn)
        let forward = offset < 0 ? offset + fullTurn : offset
        let target = Angle.degrees(current + forward + fullTurn * Double(max(additionalTurns, 0)))
        guard let part = parts.part(atRotation: target) else {
            return
        }
        worker.stop()
        state = .stop(location: part, angle: target)
    }
}

