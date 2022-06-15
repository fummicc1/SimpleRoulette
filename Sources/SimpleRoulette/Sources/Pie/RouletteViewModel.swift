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

public protocol RoulettePartHugeDelegate: AnyObject {
    var total: Double {
        get
    }

    var allParts: [PartData] {
        get
    }
}


public final class RouletteModel: ObservableObject {
    @Published public var parts: [PartData] = [] {
        didSet {
            for i in 0..<parts.count {
                parts[i].delegate = self
            }
        }
    }
    @Published private(set) var state: RouletteState = .start
    @Published public var duration: Double
    
    private var onDecide: PassthroughSubject<PartData, Never>
    public var onDecidePublisher: AnyPublisher<PartData, Never> {
        onDecide.eraseToAnyPublisher()
    }
    
    public init(
        duration: Double = 5,
        onDecide: PassthroughSubject<PartData, Never> = .init(),
        parts: [PartData]
    ) {
        self.onDecide = onDecide
        self.duration = duration
        self.parts = parts

        for i in 0..<parts.count {
            self.parts[i].delegate = self
        }
    }
    
    public func start(
        speed: RouletteSpeed = .normal,
        automaticallyStop: Bool = true
    ) {
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
            let start = (part.startAngle.degrees + Double.pi / 2).degree()
            let end = (part.endAngle.degrees + Double.pi / 2).degree()
            #if SIMPLEROULETTE || SIMPLEROULETTEDEMO
            print("label: \(part.label)")
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
}

extension RouletteModel: RoulettePartHugeDelegate {
    public var total: Double {
        Double.pi * 2
    }

    public var allParts: [PartData] {
        parts
    }
}
