//
//  RouletteViewModel.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/09/30.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

public struct RouletteSpeed: ExpressibleByFloatLiteral, Hashable {
    var value: Double
    
    public init(floatLiteral value: FloatLiteralType) {
        self.value = value
    }
    
    public static let slow: Self = .init(floatLiteral: 1000)
    public static let normal: Self = .init(floatLiteral: 2000)
    public static let fast: Self = .init(floatLiteral: 3000)
}

enum RouletteState: Hashable {
    static func == (lhs: RouletteState, rhs: RouletteState) -> Bool {
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
    case stop(location: RoulettePartType, angle: Angle)
    
    var angle: Angle {
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
    
    var speed: RouletteSpeed {
        if case RouletteState.run(_, let speed) = self {
            return speed
        }
        return .normal
    }
    
    var canStart: Bool {
        switch self {
        case .start, .stop:
            return true
        
        case .run, .pause:
            return false
        }
    }
    
    var isAnimating: Bool {
        switch self {
        case .start, .pause, .stop:
            return false
        case .run:
            return true
        }
    }
    
    func hash(into hasher: inout Hasher) {
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

public final class RouletteViewModel: ObservableObject {
    @Published private(set) var parts: [RoulettePartType] = []
    @Published private(set) var state: RouletteState = .start
    @Published private(set) var duration: Double
    
    private var onDecide: PassthroughSubject<RoulettePartType, Never>
    public var onDecidePublisher: AnyPublisher<RoulettePartType, Never> {
        onDecide.eraseToAnyPublisher()
    }
    
    public init(duration: Double, onDecide: PassthroughSubject<RoulettePartType, Never> = .init()) {
        self.onDecide = onDecide
        self.duration = duration
    }
    
    public func start(speed: RouletteSpeed = .normal, automaticallyStop: Bool = true) {
        if state.canStart {
            var angle = state.angle
            angle.degrees += speed.value
            self.state = RouletteState.run(angle: angle, speed: speed)
            if automaticallyStop {
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    self.stop()
                }
            }
        }
    }
    
    public func stop() {
        if !state.isAnimating {
            return
        }
        guard case let RouletteState.run(angle, _) = state else {
            return
        }
        var degrees = CGFloat(angle.degrees)
        #if SIMPLEROULETTE || SIMPLEROULETTEDEMO
        print("Pure Angle degreees: \(degrees)")
        #endif
        
        while degrees > 360 {
            degrees -= 360
        }
        
        degrees =  360 - degrees
        
        
        #if SIMPLEROULETTE || SIMPLEROULETTEDEMO
        print("Processed Angle degreees: \(degrees)")
        #endif

        for part in parts {
            let start = (part.startRadian + Double.pi / 2).degree()
            let end = (part.endRadian + Double.pi / 2).degree()
            #if SIMPLEROULETTE || SIMPLEROULETTEDEMO
            print("name: \(part.name)")
            print("start: \(start)")
            print("end: \(end)")
            #endif
            
            if checkIfContainsPoint(from: CGFloat(start), to: CGFloat(end), point: degrees) {
                state = .stop(location: part, angle: angle)
                onDecide.send(part)
                objectWillChange.send()
                break
            }
        }

    }
    
    func update<State, V: Equatable>(to state: inout State, keypath: WritableKeyPath<State, V>, _ value: V) {
        if state[keyPath: keypath] != value {
            state[keyPath: keypath] = value
        }
    }
    
    private func checkIfContainsPoint(from source: CGFloat, to destination: CGFloat, point: CGFloat) -> Bool {
        return source <= point && destination > point
    }
    
    public func configureWithHuge(_ params: RouletteHugeConfigurable...) {
        self.parts = params.enumerated().map({ (index, configurable) in
            Roulette.HugePart(
                name: configurable.name,
                huge: configurable.huge,
                delegate: self,
                index: index,
                fillColor: configurable.fill,
                strokeColor: configurable.stroke
            )
        })
    }
    
    public func configureWithAngle(_ parts: [RouletteAngleConfigurable]) {
        self.parts = parts.enumerated().map({ (index, configurable) in
            Roulette.AnglePart(
                name: configurable.name,
                startAngle: configurable.start,
                endAngle: configurable.end,
                index: index,
                fillColor: configurable.fill,
                strokeColor: configurable.stroke
            )
        })
    }
}

extension RouletteViewModel: RoulettePartHugeDelegate {
    public var total: Double {
        Double.pi * 2
    }
    
    public var allHuge: [Roulette.HugePart.Kind] {
        parts.compactMap { $0 as? Roulette.HugePart }.map { $0.huge }
    }
}

public struct RouletteHugeConfigurable {
    public init(
        name: String,
        huge: Roulette.HugePart.Kind,
        fill: Color = UIColor.secondarySystemBackground.color,
        stroke: Color = UIColor.systemGray4.color
    ) {
        self.name = name
        self.huge = huge
        self.fill = fill
        self.stroke = stroke
    }
    
    let name: String
    let huge: Roulette.HugePart.Kind
    let fill: Color
    let stroke: Color
}

public struct RouletteAngleConfigurable {
    public init(
        name: String,
        start: Roulette.Angle,
        end: Roulette.Angle,
        fill: Color = UIColor.secondarySystemBackground.color,
        stroke: Color = UIColor.systemGray4.color
    ) {
        self.name = name
        self.start = start
        self.end = end
        self.fill = fill
        self.stroke = stroke
    }
    
    let name: String
    let start: Roulette.Angle
    let end: Roulette.Angle
    let fill: Color
    let stroke: Color
}
