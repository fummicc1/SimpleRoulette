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
    /// From [0, 2pi)
    var startRadianAngle: Double { get }
    /// From [0, 2pi)
    var endRadianAngle: Double { get }
    var fillColor: UIColor { get }
    var strokeColor: UIColor { get }
}

public enum Roulette {
    
    public struct HugePart {
        public var id: UUID = .init()
        /// text to display on Roulette.
        public var name: String
        public var huge: Kind
        public weak var delegate: RoulettePartHugeDelegate?
        /// position. Start from 0.
        public var index: Int
        public var fillColor: UIColor
        public var strokeColor: UIColor
        
        public init(
            name: String,
            huge: Kind,
            delegate: RoulettePartHugeDelegate?,
            index: Int,
            fillColor: UIColor = .secondarySystemBackground,
            strokeColor: UIColor = .systemGray4
        ) {
            self.name = name
            self.huge = huge
            self.delegate = delegate
            self.index = index
            self.fillColor = fillColor
            self.strokeColor = strokeColor
        }
    }
    
    public struct AnglePart {
        public var id: UUID = .init()
        /// text to display on Roulette.
        public var name: String
        public var startAngle: Roulette.Angle
        public var endAngle: Roulette.Angle
        /// position.
        public var index: Int
        public var fillColor: UIColor
        public var strokeColor: UIColor
        
        public init(
            name: String,
            startAngle: Roulette.Angle,
            endAngle: Roulette.Angle,
            index: Int,
            fillColor: UIColor = .secondarySystemBackground,
            strokeColor: UIColor = .systemGray4
        ) {
            self.name = name
            self.startAngle = startAngle
            self.endAngle = endAngle
            self.index = index
            self.fillColor = fillColor
            self.strokeColor = strokeColor
        }
    }
}

extension Roulette.AnglePart: RoulettePartType {
    public var startRadianAngle: Double {
        startAngle.value
    }
    
    public var endRadianAngle: Double {
        endAngle.value
    }
}

extension Roulette.HugePart: RoulettePartType {
    
    func getPreviousEndAngle() -> Double {
        guard let delegate = delegate else {
            return .zero
        }
        var previousEndAngle: Double = 0
        if index > 0 {
            for i in 0..<index {
                let thatHuge = delegate.allHuge[i]
                let ratio = Double(thatHuge.area) / Double(delegate.allHuge.reduce(0, { $0 + $1.area }))
                previousEndAngle += ratio * delegate.total
            }
        }
        previousEndAngle -= Double.pi / 2
        assert(previousEndAngle >= -Double.pi / 2 && previousEndAngle <= Double.pi * 1.5)
        return previousEndAngle
    }
    
    public var startRadianAngle: Double {
        return getPreviousEndAngle()
    }
    
    public var endRadianAngle: Double {
        guard let delegate = delegate else { 
            return .zero
        }
        let ratio = Double(huge.area) / Double(delegate.allHuge.reduce(0, { $0 + $1.area }))
        return delegate.total * ratio + getPreviousEndAngle()
    }
    
    public enum Kind: Hashable {
        case large
        case normal
        case small
        
        var area: Int {
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


public protocol RoulettePartHugeDelegate: AnyObject {
    var allHuge: [Roulette.HugePart.Kind] { get }
    var total: Double { get }
}
