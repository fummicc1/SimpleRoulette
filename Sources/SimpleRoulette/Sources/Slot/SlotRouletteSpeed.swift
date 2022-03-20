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

    // Note: 1秒ごとに角度が1増える
    /// 1秒で1回転
    public static var normal = SlotRouletteSpeed(floatLiteral: 360)
    /// 2秒で1回転
    public static var slow = SlotRouletteSpeed(floatLiteral: 180)
    /// 1秒で2回転
    public static var hight = SlotRouletteSpeed(floatLiteral: 720)

    public static func random() -> SlotRouletteSpeed {
        let random = Int.random(in: 180...720)
        return SlotRouletteSpeed(floatLiteral: FloatLiteralType(random))
    }
}
