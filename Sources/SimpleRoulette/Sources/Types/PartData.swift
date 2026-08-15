//
//  RoulettePart.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/05/29.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation
import SwiftUI

/// Content displayed inside a roulette part.
public enum Content: Sendable {
    /// A plain text label.
    case label(String)

    /// An arbitrary SwiftUI view.
    ///
    /// The view is built lazily by a `@Sendable` closure rather than stored
    /// directly, because `AnyView` is not `Sendable` and ``PartData`` must be.
    /// Anything the closure captures therefore has to be `Sendable` too.
    ///
    /// ```swift
    /// PartData(
    ///     index: 0,
    ///     content: .custom { AnyView(Image(systemName: "star.fill")) },
    ///     area: .flex(1)
    /// )
    /// ```
    case custom(@Sendable () -> AnyView)

    @ViewBuilder
    public var view: some View {
        switch self {
        case .label(let string):
            Text(string)
        case .custom(let build):
            build()
        }
    }

    /// The text of a ``Content/label(_:)`` part, or `nil` for a custom view.
    public var text: String? {
        switch self {
        case .label(let string):
            return string
        case .custom:
            return nil
        }
    }
}

/// Defines the area (angle) of a roulette part.
public enum PartArea: Sendable {
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
            let total = flexes.map(\.value).reduce(0, +)
            guard total > 0 else { return 0 }
            let rate = Double(flex.value) / Double(total)
            return remain * rate
        }
    }
}


/// Data representing a single part of the roulette.
public struct PartData: Identifiable, Hashable, Sendable {

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
        lineWidth: Double = 2
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
    public var startAngle: Angle = .zero
    public var endAngle: Angle = .zero

    public struct Flex: ExpressibleByIntegerLiteral, Hashable, Sendable {

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

// MARK: - Angle Calculation

extension Array where Element == PartData {
    /// Calculates and assigns start/end angles to each part based on their areas.
    public mutating func calculateAngles() {
        let areas = self.map(\.area)
        var currentAngle = Angle.zero
        for i in indices {
            self[i].startAngle = currentAngle
            let degrees = self[i].area.getDegree(all: areas)
            self[i].endAngle = currentAngle + .degrees(degrees)
            currentAngle = self[i].endAngle
        }
    }
}
