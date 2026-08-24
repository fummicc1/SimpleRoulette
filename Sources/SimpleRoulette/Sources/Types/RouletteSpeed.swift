//
//  RouletteSpeed.swift
//  SimpleRoulette
//

import Foundation

/// ``RouletteSpeed`` expresses a speed of roulette rotation.
///
/// The value corresponds to progressive degrees per second.
///
/// There are predefined speed constants:
/// - ``RouletteSpeed/slow``: rotates View once per second.
/// - ``RouletteSpeed/normal``: rotates View twice per second.
/// - ``RouletteSpeed/fast``: rotates View 4 times per second.
/// - ``RouletteSpeed/high``: alias for fast.
/// - ``RouletteSpeed/idle``: never rotates.
/// - ``RouletteSpeed/random()``: decide the speed randomly.
public struct RouletteSpeed: RouletteSpeedProtocol, ExpressibleByFloatLiteral, Sendable {
    /// Internal value representing degrees per second.
    public var value: Double

    public init(floatLiteral value: FloatLiteralType) {
        self.value = value
    }

    /// The rotation speed in degrees per second.
    public var degreesPerSecond: Double {
        value
    }

    /// Rotate 1 cycle per second.
    public static let slow: Self = .init(floatLiteral: 360)

    /// Rotate 2 cycles per second.
    public static let normal: Self = .init(floatLiteral: 720)

    /// Rotate 4 cycles per second.
    public static let fast: Self = .init(floatLiteral: 1440)

    /// Rotate 4 cycles per second (alias for fast).
    public static let high: Self = fast

    /// Not rotate at all.
    public static let idle: Self = .init(floatLiteral: 0)

    /// Decide speed randomly in range [1°, 2000°] per second.
    public static func random() -> RouletteSpeed {
        let random = Int.random(in: 1...2000)
        return RouletteSpeed(floatLiteral: FloatLiteralType(random))
    }
}
