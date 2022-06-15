//
//  SlotRouletteSpeed.swift
//  
//
//  Created by Fumiya Tanaka on 2022/02/06.
//

import Foundation

public struct SlotRouletteSpeed: ExpressibleByFloatLiteral, Hashable {
    public var value: Double

    public init(floatLiteral value: FloatLiteralType) {
        self.value = value
    }

    /// increase 1° per second.
    public static var normal = SlotRouletteSpeed(floatLiteral: 360)
    /// increase 0.5° per second.
    public static var slow = SlotRouletteSpeed(floatLiteral: 180)
    /// increase 2° per second.
    public static var hight = SlotRouletteSpeed(floatLiteral: 720)

    /// Decide speed randomly in range [0.5°, 2°] per second.
    public static func random() -> SlotRouletteSpeed {
        let random = Int.random(in: 180...720)
        return SlotRouletteSpeed(
            floatLiteral: FloatLiteralType(random)
        )
    }
}
