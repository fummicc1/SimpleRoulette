//
//  RouletteSpeedProtocol.swift
//  SimpleRoulette
//
//  Created by Claude on 2024.
//

import Foundation

/// Protocol that defines the speed configuration for roulette animations.
///
/// Conforming types can be used with any roulette variant (Pie or Slot).
public protocol RouletteSpeedProtocol: Hashable, Sendable {
    /// The rotation speed in degrees per second.
    var degreesPerSecond: Double { get }

    /// Slow rotation speed.
    static var slow: Self { get }

    /// Normal rotation speed.
    static var normal: Self { get }

    /// Fast rotation speed.
    static var fast: Self { get }

    /// High rotation speed (alias for fast).
    static var high: Self { get }

    /// No rotation (idle state).
    static var idle: Self { get }

    /// Generate a random speed within the valid range.
    static func random() -> Self
}
