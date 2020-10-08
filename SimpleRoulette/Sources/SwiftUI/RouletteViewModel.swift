//
//  RouletteViewModel.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/09/30.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation
import SwiftUI

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
    
    public init() {
    }
    
    func start() {
        if state.canStart {
            state = .prepare
            timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { _ in
                self.state = .run
                self.config.angle.degrees += 1
                self.objectWillChange.send()
            })
        }
    }
    
    func stop() {
        if !state.isAnimating {
            return
        }
        timer.invalidate()
        var angle = CGFloat(config.angle.degrees)
        if angle < 0 {
            angle += CGFloat.pi * 2
        }
        
        if angle > CGFloat.pi * 2 {
            angle -= CGFloat.pi * 2
        }
        
        print("Angle: \(angle.degree())")

        for part in parts {
            let start = part.startRadianAngle + Double(angle)
            let end = part.endRadianAngle + Double(angle)
            print("start: \(start.degree())")
            print("end: \(end.degree())")
            
            if checkIfContainsPoint(from: CGFloat(start), to: CGFloat(end), point: CGFloat.pi * 1.5) {
                state = .stop(location: part)
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
    
    public func updateParts(_ parts: [RoulettePartType]) {
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
