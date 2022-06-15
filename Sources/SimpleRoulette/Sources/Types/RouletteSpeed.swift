import Foundation

public struct RouletteSpeed: ExpressibleByFloatLiteral, Hashable {
    var value: Double

    public init(floatLiteral value: FloatLiteralType) {
        self.value = value
    }

    public static let slow: Self = .init(floatLiteral: 1000)
    public static let normal: Self = .init(floatLiteral: 2000)
    public static let fast: Self = .init(floatLiteral: 3000)

    /// Decide speed randomly
    public static func random() -> RouletteSpeed {
        let random = Int.random(in: 800...4000)
        return RouletteSpeed(
            floatLiteral: FloatLiteralType(random)
        )
    }
}
