import Foundation


/// ``RouletteSpeed`` expresses a speed of roulette rotation. value is corresponding to progressive degrees per
///
/// There are five predefined ``RouletteSpeed``.
/// - ``RouletteSpeed/slow``: rotates View once per second.
/// - ``RouletteSpeed/normal``:  rotates View twice per second.
/// - ``RouletteSpeed/fast``: rotates View 4 times per second.
/// - ``RouletteSpeed/idle``: never rotates.
/// - ``RouletteSpeed/random()``: decide the speed in random.
public struct RouletteSpeed: ExpressibleByFloatLiteral, Hashable {
    var value: Double

    public init(floatLiteral value: FloatLiteralType) {
        self.value = value
    }

    /// Rotate 1 cycle per second.
    public static let slow: Self = .init(floatLiteral: 360)
    /// Rotate 2 cycle per second.
    public static let normal: Self = .init(floatLiteral: 720)
    /// Rotate 4 cycle per second.
    public static let fast: Self = .init(floatLiteral: 1440)
    /// Not rotate at all.
    public static let idle: Self = .init(floatLiteral: 0)

    /// Decide speed randomly
    public static func random() -> RouletteSpeed {
        let random = Int.random(in: 1...2000)
        return RouletteSpeed(
            floatLiteral: FloatLiteralType(random)
        )
    }
}
