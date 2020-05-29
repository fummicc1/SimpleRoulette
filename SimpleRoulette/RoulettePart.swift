//
//  RoulettePart.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/05/29.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation

public struct RoulettePart {
    public let id: UUID = .init()
    /// text to display on Roulette.
    public let name: String
    public let startAngle: Double
    public let endAngle: Double
    /// Amount of area.
    public let value: Double
    /// position.
    public let index: Int
    
    public init(name: String, startAngle: Double, endAngle: Double, value: Double, index: Int) {
        self.name = name
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.value = value
        self.index = index
    }
}
