//
//  RoulettePart.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/05/29.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation
import SwiftUI

public enum Content {
    case label(String)
    case custom(AnyView)

    public var view: AnyView {
        switch self {
        case .label(let string):
            return AnyView(Text(string))
        case .custom(let anyView):
            return anyView
        }
    }

    public var text: String? {
        switch self {
        case .label(let string):
            return string
        case .custom:
            return nil
        }
    }
}

public enum PartArea {
    case degree(Double)
    case flex(PartData.Flex)

    func getDegree(all: [PartArea]) -> Double {
        switch self {
        case .degree(let double):
            return double
        case .flex(let flex):
            var fixed: Double = 0
            var flexes: [PartData.Flex] = []
            for e in all {
                switch e {
                case .degree(let double):
                    fixed += double
                case .flex(let flex):
                    flexes.append(flex)
                }
            }
            let remain = 360 - fixed
            let rate = Double(flex.value) / Double(flexes.map(\.value).reduce(0, { $0 + $1 }))
            return remain * rate
        }
    }
}


public struct PartData: Identifiable, Hashable {
    public static func == (lhs: PartData, rhs: PartData) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public init(
        index: Int,
        content: Content,
        area: PartArea,
        fillColor: Color = .secondarySystemBackground,
        strokeColor: Color = .systemGray,
        lineWidth: Double = 2,
        delegate: RoulettePartHugeDelegate? = nil
    ) {
        self.index = index
        self.content = content
        self.area = area
        self.fillColor = fillColor
        self.strokeColor = strokeColor
        self.lineWidth = lineWidth
    }

    public var id: String {
        String(index)
    }
    public var content: Content
    public var index: Int
    public var area: PartArea
    public var fillColor: Color
    public var strokeColor: Color
    public var lineWidth: Double
    public var startAngle: Angle!
    public var endAngle: Angle!
    public weak var delegate: RoulettePartHugeDelegate? {
        didSet {
            guard let delegate = delegate else {
                return
            }
            let all = delegate.allParts
            var startAngle = Angle()
            for element in all {
                if element.index == index {
                    break
                }
                let area = element.area
                let deg = area.getDegree(
                    all: all.map(\.area)
                )
                startAngle += Angle.degrees(deg)
            }
            self.startAngle = startAngle
            self.endAngle = startAngle + Angle.degrees(
                area.getDegree(
                    all: all.map(\.area)
                )
            )
        }
    }

    public struct Flex: ExpressibleByIntegerLiteral, Hashable {

        public var value: Int

        public init(integerLiteral value: IntegerLiteralType) {
            self.value = value
        }
    }

    func paddingX(radius: Double) -> Double {
        let mid = (startAngle + endAngle) / 2
        return radius / 2 * cos(mid.radians)
    }

    func paddingY(radius: Double) -> Double {
        let mid = (startAngle + endAngle) / 2
        return radius / 2 * sin(mid.radians)
    }
}
