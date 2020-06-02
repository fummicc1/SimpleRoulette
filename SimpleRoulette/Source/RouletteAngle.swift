//
//  RouletteAngle.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/05/31.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation

extension Roulette {
    public struct Angle {
        /// Radian. [0, 2pi)
        public var value: Double {
            accuracy.value
        }
        
        var accuracy: AccurateDouble
        
        /// initializer with radian
        /// - Parameters:
        ///   - radian: radian. range [0, 2pi)
        public init(radian: Double) {
            accuracy = .init(value: radian)
        }
        
        /// initializer with degree.
        /// - Parameters:
        ///   - degree: degree. range [0, 360)
        public init(degree: Double) {
            accuracy = .init(value: degree.radian())
        }
    }
}
