//
//  RouletteWorker.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2022/02/06.
//

import Foundation
import SwiftUI

/// A worker that manages the rotation animation for roulette components.
///
/// This class uses Swift Concurrency to drive smooth animations.
@MainActor
public final class RouletteWorker: Sendable {

    private var animationTask: Task<Void, Never>?
    private var currentValue: Double = 0
    private var continuation: AsyncStream<Double>.Continuation?

    public init() {}

    /// Starts the animation and returns an async stream of angle values.
    ///
    /// - Parameters:
    ///   - speed: The rotation speed.
    ///   - value: Optional starting angle in degrees.
    ///   - automaticallyStopAfter: Optional duration after which the animation stops.
    /// - Returns: An async stream of angle values in degrees.
    public func start(
        speed: RouletteSpeed,
        from value: Double? = nil,
        automaticallyStopAfter: Duration? = nil
    ) -> AsyncStream<Double> {
        stop()

        currentValue = value ?? 0

        return AsyncStream { continuation in
            self.continuation = continuation

            self.animationTask = Task { @MainActor in
                let startTime = ContinuousClock.now
                let intervalNanoseconds: UInt64 = 16_666_667 // ~60fps (1/60 second)

                while !Task.isCancelled {
                    try? await Task.sleep(nanoseconds: intervalNanoseconds)

                    guard !Task.isCancelled else { break }

                    self.currentValue += speed.degreesPerSecond * (Double(intervalNanoseconds) / 1_000_000_000)
                    continuation.yield(self.currentValue)

                    if let stopAfter = automaticallyStopAfter {
                        let elapsed = ContinuousClock.now - startTime
                        if elapsed >= stopAfter {
                            break
                        }
                    }
                }
                continuation.finish()
            }

            continuation.onTermination = { @Sendable _ in
                Task { @MainActor in
                    self.animationTask?.cancel()
                }
            }
        }
    }

    /// Legacy start method for backward compatibility.
    ///
    /// - Parameters:
    ///   - speed: The rotation speed.
    ///   - value: Optional starting angle in degrees.
    ///   - automaticallyStopAfter: Optional duration in seconds after which the animation stops.
    ///   - callback: Called with the current angle value.
    ///   - onEnd: Called when the animation ends.
    public func start(
        speed: RouletteSpeed,
        from value: Double? = nil,
        automaticallyStopAfter: Double?,
        callback: @escaping @MainActor (Double) -> Void,
        onEnd: @escaping @MainActor () -> Void
    ) {
        let duration: Duration? = automaticallyStopAfter.map { .seconds($0) }
        let stream = start(speed: speed, from: value, automaticallyStopAfter: duration)

        Task { @MainActor in
            for await degrees in stream {
                callback(degrees)
            }
            onEnd()
        }
    }

    /// Stops the animation and resets the state.
    public func stop() {
        animationTask?.cancel()
        animationTask = nil
        continuation?.finish()
        continuation = nil
        currentValue = 0
    }

    /// Pauses the animation, preserving the current value.
    public func pause() {
        animationTask?.cancel()
        animationTask = nil
        continuation?.finish()
        continuation = nil
    }
}
