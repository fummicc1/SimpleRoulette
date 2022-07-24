//
//  RouletteModel.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/09/30.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

/// ``RouletteDataDelegate`` is delegate that manages all of ``PartData`` which are shown at ``RouletteView``.
public protocol RouletteDataDelegate: AnyObject {

    /// Total degree of Roulette.
    /// - Note: This is usually 360° degree.
    var total: Double {
        get
    }

    /// all of ``PartData`` which are used in Roulette should be included in ``allParts``.
    var allParts: [PartData] {
        get
    }
}

/// ``RouletteModel`` is a model that interact with ``View`` and manage state of Roulette.
public final class RouletteModel: ObservableObject {
    @Published public var parts: [PartData] = []
    @Published public var state: RouletteState = .start
    @Published public var duration: Double
    
    public var onDecide: PassthroughSubject<PartData, Never>
    public var onDecidePublisher: AnyPublisher<PartData, Never> {
        onDecide.eraseToAnyPublisher()
    }
    
    public init(
        duration: Double = 3,
        onDecide: PassthroughSubject<PartData, Never> = .init(),
        parts: [PartData]
    ) {
        self.onDecide = onDecide
        self.duration = duration
        self.parts = parts

        updateDelegate()
    }

    public func updateParts(_ parts: [PartData]) {
        self.parts = parts
        updateDelegate()
    }

    private func updateDelegate() {
        for i in 0..<parts.count {
            parts[i].delegate = self
        }
    }
    
    public func start(
        speed _speed: RouletteSpeed? = nil,
        automaticallyStop: Bool = true
    ) {
        let speed = _speed ?? RouletteSpeed.random()
        if state.canStart {
            var angle = state.angle
            angle.degrees += speed.value
            self.state = RouletteState.run(angle: angle, speed: speed)
            if automaticallyStop {
                DispatchQueue.main.asyncAfter(
                    deadline: .now() + duration
                ) {
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
        var degrees = angle.degrees
        #if SIMPLEROULETTE || SIMPLEROULETTEDEMO
        print("Pure Angle degreees: \(degrees)")
        #endif
        
        while degrees >= 360 {
            degrees -= 360
        }
        
        #if SIMPLEROULETTE || SIMPLEROULETTEDEMO
        print("Processed Angle degreees: \(degrees)")
        #endif

        for part in parts {
            let start = part.startAngle.degrees + degrees
            let end = part.endAngle.degrees + degrees
            #if SIMPLEROULETTE || SIMPLEROULETTEDEMO
            print("label: \(part.label)")
            print("start: \(start)")
            print("end: \(end)")
            #endif

            // Angle of ▼
            let stopDegree: Double = 270 + 360 * Double(Int(start) / 360)

            if start <= stopDegree && end >= stopDegree {
                state = .stop(location: part, angle: angle)
                onDecide.send(part)
                objectWillChange.send()
                return
            }
        }
    }
    
    func update<State, V: Equatable>(to state: inout State, keypath: WritableKeyPath<State, V>, _ value: V) {
        if state[keyPath: keypath] != value {
            state[keyPath: keypath] = value
        }
    }
}

extension RouletteModel: RouletteDataDelegate {
    public var total: Double {
        Double.pi * 2
    }

    public var allParts: [PartData] {
        parts
    }
}
