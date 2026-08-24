//
//  RouletteAnimating.swift
//  SimpleRoulette
//
//  Created by Claude on 2024.
//

import Foundation
import SwiftUI

/// Protocol that defines the animation engine for roulette components.
///
/// Conforming types manage the rotation animation using Swift Concurrency.
@MainActor
public protocol RouletteAnimating: AnyObject, Sendable {
    associatedtype Speed: RouletteSpeedProtocol

    /// Starts the animation with the specified speed.
    ///
    /// - Parameters:
    ///   - speed: The rotation speed.
    ///   - from: Optional starting angle in degrees.
    ///   - automaticallyStopAfter: Optional duration after which the animation stops.
    /// - Returns: An async stream of angle values in degrees.
    func start(
        speed: Speed,
        from value: Double?,
        automaticallyStopAfter: Duration?
    ) -> AsyncStream<Double>

    /// Stops the animation and resets the state.
    func stop()

    /// Pauses the animation, preserving the current state.
    func pause()
}

/// Protocol that defines the state of a roulette component.
public protocol RouletteStateProtocol: Hashable, Sendable {
    /// Whether the roulette is currently animating.
    var isAnimating: Bool { get }

    /// Whether the roulette can start a new animation.
    var canStart: Bool { get }

    /// The current rotation angle, if available.
    var angle: Angle? { get }
}
