//
//  RoulettePart.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/05/29.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation
import SwiftUI

public struct Roulette {

    public struct PartData {
        public var id: String
        public var content: (() -> AnyView)?
        public var label: String?
        public var index: Int
        public var radians: Double?
        public var flex: Int?
        public var fillColor: Color
        public var strokeColor: Color
        public var lineWidth: Double

        public static func withDegree(
            id: String,
            content: (() -> AnyView)?,
            label: String?,
            index: Int,
            degress: Double,
            fillColor: Color,
            strokeColor: Color,
            lineWidth: Double
        ) -> PartData {
            PartData(
                id: id,
                content: content,
                label: label,
                index: index,
                radians: degress * Double.pi / 180,
                fillColor: fillColor,
                strokeColor: strokeColor,
                lineWidth: lineWidth
            )
        }

        public func withRadians(
            id: String,
            content: (() -> AnyView)?,
            label: String?,
            index: Int,
            radians: Double,
            fillColor: Color,
            strokeColor: Color,
            lineWidth: Double
        ) -> PartData {
            PartData(
                id: id,
                content: content,
                label: label,
                index: index,
                radians: radians,
                fillColor: fillColor,
                strokeColor: strokeColor,
                lineWidth: lineWidth
            )
        }

        public func withFlex(
            id: String,
            content: (() -> AnyView)?,
            label: String?,
            index: Int,
            flex: Int,
            fillColor: Color,
            strokeColor: Color,
            lineWidth: Double
        ) -> PartData {
            PartData(
                id: id,
                content: content,
                label: label,
                index: index,
                flex: flex,
                fillColor: fillColor,
                strokeColor: strokeColor,
                lineWidth: lineWidth
            )
        }

    }
}

extension Roulette.PartData {
    
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
