import Foundation
import SwiftUI
import Combine


public enum RouletteState: Hashable {
    public static func == (lhs: RouletteState, rhs: RouletteState) -> Bool {
        switch lhs {
        case .start:
            if case RouletteState.start = rhs {
                return true
            }
            return false

        case .run(let angle, let speed):
            if case let RouletteState.run(rightAngle, rightSpeed) = rhs {
                if angle == rightAngle && speed == rightSpeed {
                    return true
                }
            }
            return false

        case .pause(let angle, let speed):
            if case let RouletteState.pause(rightAngle, rightSpeed) = rhs {
                if angle == rightAngle && speed == rightSpeed {
                    return true
                }
            }
            return false

        case .stop(let location, let angle):
            if case let RouletteState.stop(rightLocation, rightAngle) = rhs {
                if angle == rightAngle && location.id == rightLocation.id {
                    return true
                }
            }
            return false

        }
    }

    case start
    case run(angle: Angle, speed: RouletteSpeed)
    case pause(angle: Angle, speed: RouletteSpeed)
    case stop(location: PartData, angle: Angle)

    public var angle: Angle {
        let degrees: Double
        if case RouletteState.run(let angle, _) = self {
            degrees = angle.degrees
        } else if case RouletteState.pause(let angle, _) = self {
            degrees = angle.degrees
        } else if case RouletteState.stop(_, let angle) = self {
            degrees = angle.degrees
        } else {
            degrees = 0
        }
        return Angle(degrees: degrees)
    }

    public var speed: RouletteSpeed {
        if case RouletteState.run(_, let speed) = self {
            return speed
        }
        return .normal
    }

    public var canStart: Bool {
        switch self {
        case .start, .stop:
            return true

        case .run, .pause:
            return false
        }
    }

    public var isAnimating: Bool {
        switch self {
        case .start, .pause, .stop:
            return false
        case .run:
            return true
        }
    }

    public func hash(into hasher: inout Hasher) {
        switch self {
        case .start:
            break

        case .run(let angle, let speed):
            hasher.combine(angle)
            hasher.combine(speed)

        case .pause(let angle, let speed):
            hasher.combine(angle)
            hasher.combine(speed)

        case .stop(let location, let angle):
            hasher.combine(location.id)
            hasher.combine(angle)

        }
    }
}
