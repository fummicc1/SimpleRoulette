//
//  RoulettePart.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/05/29.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation
import UIKit

public protocol RoulettePartType {
    var id: UUID { get }
    var name: String { get }
    var index: Int { get }
    var startRadianAngle: Double { get }
    var endRadianAngle: Double { get }
    var fillColor: UIColor { get }
    var strokeColor: UIColor { get }
}

public struct RoulettePart {
    public var id: UUID = .init()
    /// text to display on Roulette.
    public var name: String
    public var startAngle: RouletteAngle
    public var endAngle: RouletteAngle
    /// position.
    public var index: Int
    public var fillColor: UIColor
    public var strokeColor: UIColor
    
    public init(name: String, startAngle: RouletteAngle, endAngle: RouletteAngle, index: Int, fillColor: UIColor = .black, strokeColor: UIColor = .gray) {
        self.name = name
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.index = index
        self.fillColor = fillColor
        self.strokeColor = strokeColor
    }
    
    /// initializer with Huge
    /// - Parameters:
    ///   - huge: Huge enum.
    ///   - elements: all of Huges. nessecarry to calculate ratio value.
    ///   - total: total value. [value = ratio * total] Not radian but degree.
    ///   - fromTop:flag if zero is from top (pi / 2). default is false.
    public init(
        name: String,
        index: Int,
        fillColor: UIColor = .black,
        strokeColor: UIColor = .gray,
        huge: Huge,
        elements: [Huge],
        total: Double = Double.pi * 2,
        fromTop: Bool = false
    ) {
        fatalError()
    }
}

extension RoulettePart: RoulettePartType {
    public var startRadianAngle: Double {
        startAngle.value
    }
    
    public var endRadianAngle: Double {
        endAngle.value
    }
}

extension RoulettePart {
    public enum Huge {
        case large
        case normal
        case small
        
        var value: Int {
            switch self {
            case .large:
                return 3
                
            case .normal:
                return 2
                
            case .small:
                return 1
            }
        }
    }
}
