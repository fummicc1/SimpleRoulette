//
//  SlotRouletteSpeed.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2022/02/06.
//

import Foundation

/// Speed configuration for slot roulette.
///
/// - Note: Consider using ``RouletteSpeed`` instead for unified speed configuration.
@available(*, deprecated, message: "Use RouletteSpeed instead for unified speed configuration")
public struct SlotRouletteSpeed: RouletteSpeedProtocol, ExpressibleByFloatLiteral, Sendable {
    public var value: Double

    public init(floatLiteral value: FloatLiteralType) {
        self.value = value
    }

    /// The rotation speed in degrees per second.
    public var degreesPerSecond: Double {
        value
    }

    /// Rotate 1 cycle per second.
    public static let normal = SlotRouletteSpeed(floatLiteral: 360)

    /// Rotate 0.5 cycles per second.
    public static let slow = SlotRouletteSpeed(floatLiteral: 180)

    /// Rotate 2 cycles per second.
    public static let fast = SlotRouletteSpeed(floatLiteral: 720)

    /// Rotate 2 cycles per second (alias for fast).
    public static let high = SlotRouletteSpeed(floatLiteral: 720)

    /// Not rotate at all.
    public static let idle = SlotRouletteSpeed(floatLiteral: 0)

    /// Decide speed randomly in range [180°, 720°] per second.
    public static func random() -> SlotRouletteSpeed {
        let random = Int.random(in: 180...720)
        return SlotRouletteSpeed(floatLiteral: FloatLiteralType(random))
    }
}
