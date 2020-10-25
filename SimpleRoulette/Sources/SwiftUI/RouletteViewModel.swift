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

public struct RouletteSpeed: ExpressibleByFloatLiteral {
    var value: Double
    
    public init(floatLiteral value: FloatLiteralType) {
        self.value = value
    }
    
    public static let normal: Self = .init(floatLiteral: 2000)
    public static let slow: Self = .init(floatLiteral: 1000)
    public static let fast: Self = .init(floatLiteral: 3000)
}

enum RouletteState {
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
        } else if case RouletteState.run(_, let speed) = self {
            return speed
        }
        return .normal
    }
    
    var canStart: Bool {
        switch self {
        case .start:
            return true
        
        case .run, .pause, .stop:
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
            var angle = Angle()
            angle.degrees = speed.value
            self.state = RouletteState.run(angle: angle, speed: speed)
            self.objectWillChange.send()
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
            let start = (part.startRadianAngle + Double.pi / 2).degree()
            let end = (part.endRadianAngle + Double.pi / 2).degree()
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
    
    public func configureParts(_ parts: [RoulettePartType]) {
        self.parts = parts
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
