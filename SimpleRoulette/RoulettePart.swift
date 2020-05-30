//
//  RoulettePart.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/05/29.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation
import UIKit

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

public struct RoulettePart {
    public let id: UUID = .init()
    /// text to display on Roulette.
    public let name: String
    public let startAngle: RouletteAngle
    public let endAngle: RouletteAngle
    /// position.
    public let index: Int
    public let fillColor: UIColor
    public let strokeColor: UIColor
    
    public init(name: String, startAngle: RouletteAngle, endAngle: RouletteAngle, index: Int, fillColor: UIColor = .black, strokeColor: UIColor = .gray) {
        self.name = name
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.index = index
        self.fillColor = fillColor
        self.strokeColor = strokeColor
    }
}
