//
//  RoulettePart.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/05/29.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation
import SwiftUI

public protocol RoulettePartType {
    var id: String { get }
    var content: (() -> AnyView)? { get }
    var label: String { get }
    var index: Int { get }
    /// [0, 2pi)
    var startRadian: Double { get }
    /// [0, 2pi)
    var endRadian: Double { get }
    var fillColor: Color { get }
    var strokeColor: Color { get }
}

public enum Roulette {
    
    public struct HugePart {
        public var id: String {
            label
        }
        public var label: String
        public var content: (() -> AnyView)?
        public var huge: Kind
        public weak var delegate: RoulettePartHugeDelegate?
        /// position. Begin with 0.
        public var index: Int
        public var fillColor: Color
        public var strokeColor: Color
        
        public init(
            label: String,
            huge: Kind,
            index: Int,
            fillColor: Color,
            strokeColor: Color,
            content: (() -> AnyView)?,
            delegate: RoulettePartHugeDelegate?
        ) {
            self.content = content
            self.label = label
            self.huge = huge
            self.delegate = delegate
            self.index = index
            self.fillColor = fillColor
            self.strokeColor = strokeColor
        }
    }
    
    public struct AnglePart {
        public var id: String {
            label
        }
        public var label: String
        public var content: (() -> AnyView)?
        public var startAngle: Roulette.Angle
        public var endAngle: Roulette.Angle
        /// position.
        public var index: Int
        public var fillColor: Color
        public var strokeColor: Color
        
        public init(
            label: String,
            startAngle: Roulette.Angle,
            endAngle: Roulette.Angle,
            index: Int,
            fillColor: Color,
            strokeColor: Color,
            content: (() -> AnyView)?
        ) {
            self.label = label
            self.startAngle = startAngle
            self.endAngle = endAngle
            self.index = index
            self.fillColor = fillColor
            self.strokeColor = strokeColor
            self.content = content
        }
    }
}

extension Roulette.AnglePart: RoulettePartType {
    public var startRadian: Double {
        startAngle.value
    }
    
    public var endRadian: Double {
        endAngle.value
    }
}

extension Roulette.HugePart: RoulettePartType {
    
    private func getPreviousEndAngle() -> Double {
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
    
    public var startRadian: Double {
        return getPreviousEndAngle()
    }
    
    public var endRadian: Double {
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
