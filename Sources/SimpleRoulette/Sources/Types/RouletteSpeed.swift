import Foundation

public struct RouletteSpeed: ExpressibleByFloatLiteral, Hashable {
    var value: Double

    public init(floatLiteral value: FloatLiteralType) {
        self.value = value
    }

    public static let slow: Self = .init(floatLiteral: 100)
    public static let normal: Self = .init(floatLiteral: 200)
    public static let fast: Self = .init(floatLiteral: 300)
    public static let idle: Self = .init(floatLiteral: 0)

    /// Decide speed randomly
    public static func random() -> RouletteSpeed {
        let random = Int.random(in: 80...400)
        return RouletteSpeed(
            floatLiteral: FloatLiteralType(random)
        )
    }
}
