//
//  RouletteStyle.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2026/08/15.
//

import Foundation
import SwiftUI

/// How a part's label is rotated inside its wedge.
public enum RouletteLabelOrientation: Sendable, Hashable {

    /// Reads outward from the hub, following the wedge, the way a real roulette is
    /// laid out. Labels on the left half of the wheel therefore sit upside down —
    /// fine for numbers, harder to read for words.
    case radial

    /// Follows the wedge like ``radial``, but labels on the left half of the wheel
    /// are turned a further 180° so every one of them reads upright at rest.
    case radialUpright

    /// Runs across the wedge, perpendicular to the radius.
    case tangential

    /// Stays upright whatever angle the wedge sits at.
    case fixed

    /// The rotation to apply to a label whose wedge is centred on `midAngle`.
    func rotation(midAngle: Angle) -> Angle {
        switch self {
        case .radial:
            return midAngle
        case .radialUpright:
            return isOnLeftHalf(midAngle) ? midAngle + .degrees(180) : midAngle
        case .tangential:
            return midAngle + .degrees(90)
        case .fixed:
            return .zero
        }
    }

    /// Whether a wedge centred on `angle` points into the half of the wheel where
    /// radial text would read upside down.
    private func isOnLeftHalf(_ angle: Angle) -> Bool {
        let wrapped = angle.degrees.truncatingRemainder(dividingBy: 360)
        let positive = wrapped < 0 ? wrapped + 360 : wrapped
        return positive > 90 && positive < 270
    }
}

/// Visual configuration shared by every part of a roulette.
///
/// Apply one with ``SwiftUI/View/rouletteStyle(_:)``:
///
/// ```swift
/// RouletteView(parts: parts)
///     .rouletteStyle(.pie) // the 1.x look
/// ```
public struct RouletteStyle: Sendable, Hashable {

    /// Where a label sits between the centre (`0`) and the outer edge (`1`).
    public var labelPosition: Double

    /// How a label is rotated within its wedge.
    public var labelOrientation: RouletteLabelOrientation

    /// Radius of the empty hub in the middle, as a fraction of the outer radius.
    ///
    /// `0` draws a full pie, so every separator meets in the centre.
    public var innerRadiusRatio: Double

    /// - Parameters:
    ///     - labelPosition: clamped to `0...1`.
    ///     - labelOrientation: how each label is rotated.
    ///     - innerRadiusRatio: clamped to `0...1`.
    public init(
        labelPosition: Double = 0.74,
        labelOrientation: RouletteLabelOrientation = .radial,
        innerRadiusRatio: Double = 0.22
    ) {
        self.labelPosition = min(max(labelPosition, 0), 1)
        self.labelOrientation = labelOrientation
        self.innerRadiusRatio = min(max(innerRadiusRatio, 0), 1)
    }

    /// Labels out at the rim, laid out radially, with a hub in the middle — the way
    /// a real roulette wheel is arranged. Used when no style is applied.
    ///
    /// Being a faithful radial layout, labels on the left half of the wheel sit
    /// upside down, exactly as the numbers on a real wheel do. If your labels are
    /// words rather than numbers and you would rather every one of them stayed
    /// readable, use ``RouletteLabelOrientation/radialUpright``:
    ///
    /// ```swift
    /// RouletteView(parts: parts)
    ///     .rouletteStyle(RouletteStyle(labelOrientation: .radialUpright))
    /// ```
    public static let `default` = RouletteStyle()

    /// The 1.x look: labels halfway out, laid across the wedge, no hub.
    public static let pie = RouletteStyle(
        labelPosition: 0.5,
        labelOrientation: .tangential,
        innerRadiusRatio: 0
    )
}

// MARK: - Environment

private struct RouletteStyleKey: EnvironmentKey {
    static let defaultValue: RouletteStyle = .default
}

extension EnvironmentValues {
    /// The style applied to roulettes in this view hierarchy.
    public var rouletteStyle: RouletteStyle {
        get { self[RouletteStyleKey.self] }
        set { self[RouletteStyleKey.self] = newValue }
    }
}

extension View {
    /// Applies a visual style to every roulette in this view hierarchy.
    ///
    /// ```swift
    /// RouletteView(parts: parts)
    ///     .rouletteStyle(
    ///         RouletteStyle(labelPosition: 0.8, innerRadiusRatio: 0.25)
    ///     )
    /// ```
    public func rouletteStyle(_ style: RouletteStyle) -> some View {
        environment(\.rouletteStyle, style)
    }
}
