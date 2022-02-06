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

    /// 1秒で10回転
    public static var normal = SlotRouletteSpeed(floatLiteral: 360 * 10)
    /// 1秒で3回転
    public static var slow = SlotRouletteSpeed(floatLiteral: 360 * 3)
    /// 1秒で15回転
    public static var hight = SlotRouletteSpeed(floatLiteral: 360 * 15)
}
