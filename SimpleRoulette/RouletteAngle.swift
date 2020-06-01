//
//  RouletteAngle.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/05/31.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation

public struct RouletteAngle {

    public let value: Double
    
    
    /// initializer with radian
    /// - Parameters:
    ///   - radian: radian. range [0, 2pi)
    ///   - fromTop: flag if zero is from top (pi / 2). default is false.
    public init(radian: Double, fromTop: Bool = false) {
        if fromTop {
            self.value = radian
        } else {
            self.value = radian - Double.pi / 2
        }
    }
    
    /// initializer with degree.
    /// - Parameters:
    ///   - degree: degree. range [0, 360)
    ///   - fromTop: flag if zero is from top (pi / 2). default is false.
    public init(degree: Double, fromTop: Bool = false) {
        if fromTop {
            self.value = degree.radian()
        } else {
            self.value = degree.radian() - Double.pi / 2
        }
    }
}