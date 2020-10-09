//
//  RouletteViewModel.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/09/30.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation
import SwiftUI

public struct RouletteSpeed: ExpressibleByFloatLiteral {
    var value: Double
    
    public init(floatLiteral value: FloatLiteralType) {
        self.value = value
    }
}

enum RouletteState {
    case start
    case prepare
    case run
    case pause
    case stop(location: RoulettePartType)
    
    var canStart: Bool {
        switch self {
        case .start:
            return true
        
        case .prepare, .run, .pause, .stop:
            return false
        }
    }
    
    var isAnimating: Bool {
        switch self {
        case .start, .prepare, .pause, .stop:
            return false
        case .run:
            return true
        }
    }
    
    var shouldsAnimate: Bool {
        switch self {
        case .start, .run, .pause, .stop:
            return false
        case .prepare:
            return true
        }
    }
}

public final class RouletteViewModel: ObservableObject {
    @Published private(set) var parts: [RoulettePartType] = []
    @Published private(set) var state: RouletteState = .start
    
    private(set) var config: RouletteConfig = RouletteConfig()
    
    private var timer: Timer = Timer()
    
    private var onDecide: (RoulettePartType) -> Void
    
    public init(onDecide: @escaping (RoulettePartType) -> Void) {
        self.onDecide = onDecide
    }
    
    public func start(speed: RouletteSpeed = 3.0) {
        if state.canStart {
            state = .prepare
            timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { _ in
                self.state = .run
                withAnimation {
                    self.config.angle.degrees += speed.value
                    self.objectWillChange.send()
                }
            })
        }
    }
    
    public func stop() {
        if !state.isAnimating {
            return
        }
        timer.invalidate()
        var angle = CGFloat(config.angle.degrees)
        while angle < 0 {
            angle += CGFloat.pi * 2
        }
        
        while angle > CGFloat.pi * 2 {
            angle -= CGFloat.pi * 2
        }
        
        #if SIMPLEROULETTE
        print("Angle: \(angle.degree())")
        #endif

        for part in parts {
            let start = part.startRadianAngle + Double(angle)
            let end = part.endRadianAngle + Double(angle)
            #if SIMPLEROULETTE
            print("start: \(start.degree())")
            print("end: \(end.degree())")
            #endif
            
            if checkIfContainsPoint(from: CGFloat(start), to: CGFloat(end), point: CGFloat.pi * 1.5) {
                state = .stop(location: part)
                onDecide(part)
                config.angle.degrees = 0
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
        var point = point
        if destination - point > CGFloat.pi * 2 {
            point += CGFloat.pi * 2
        }
        if point - destination > CGFloat.pi * 2 {
            point -= CGFloat.pi * 2
        }
        print("Point: \(point.degree())")
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
