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

public final class RouletteModel: ObservableObject {
    @Published public var parts: [RoulettePartType] = []
    @Published private(set) var state: RouletteState = .start
    @Published public var duration: Double
    
    private var onDecide: PassthroughSubject<RoulettePartType, Never>
    public var onDecidePublisher: AnyPublisher<RoulettePartType, Never> {
        onDecide.eraseToAnyPublisher()
    }
    
    public init(
        duration: Double,
        onDecide: PassthroughSubject<RoulettePartType, Never> = .init(),
        parts: [RoulettePartType] = []
    ) {
        self.onDecide = onDecide
        self.duration = duration
        self.parts = parts
    }

    public convenience init(
        duration: Double,
        onDecide: PassthroughSubject<RoulettePartType, Never> = .init(),
        huges: [Roulette.HugePart.Config]
    ) {
        self.init(
            duration: duration,
            onDecide: onDecide,
            parts: []
        )
        configureWithHuge(huges)
    }

    public convenience init(
        duration: Double,
        onDecide: PassthroughSubject<RoulettePartType, Never> = .init(),
        angles: [Roulette.AnglePart.Config]
    ) {
        self.init(
            duration: duration,
            onDecide: onDecide,
            parts: []
        )
        configureWithAngle(angles)
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

    func convertHugeConfig(_ parts: [Roulette.HugePart.Config]) -> [RoulettePartType] {
        return parts.enumerated().map({ (index, configurable) in
            Roulette.HugePart(
                label: configurable.label,
                huge: configurable.huge,
                index: index,
                fillColor: configurable.fill,
                strokeColor: configurable.stroke,
                content: configurable.content,
                delegate: self
            )
        })
    }

    public func configureWithHuge(_ parts: [Roulette.HugePart.Config]) {
        self.parts = convertHugeConfig(parts)
    }

    func convertAngleConfig(_ parts: [Roulette.AnglePart.Config]) -> [RoulettePartType] {
        return parts.enumerated().map({ (index, configurable) in
            Roulette.AnglePart(
                label: configurable.label,
                startAngle: configurable.start,
                endAngle: configurable.end,
                index: index,
                fillColor: configurable.fill,
                strokeColor: configurable.stroke,
                content: configurable.content
            )
        })
    }

    public func configureWithAngle(_ parts: [Roulette.AnglePart.Config]) {
        self.parts = convertAngleConfig(parts)
    }
}

extension RouletteModel: RoulettePartHugeDelegate {
    public var total: Double {
        Double.pi * 2
    }
    
    public var allHuge: [Roulette.HugePart.Kind] {
        parts.compactMap { $0 as? Roulette.HugePart }.map { $0.huge }
    }
}

extension Roulette.HugePart {
    public struct Config {
        public init(
            label: String,
            huge: Roulette.HugePart.Kind,
            fill: Color = Color.secondarySystemBackground,
            stroke: Color = .systemGray,
            content: (() -> AnyView)? = nil
        ) {
            self.label = label
            self.content = content
            self.huge = huge
            self.fill = fill
            self.stroke = stroke
        }

        let label: String
        let huge: Roulette.HugePart.Kind
        let fill: Color
        let stroke: Color
        let content: (() -> AnyView)?
    }
}

extension Roulette.AnglePart {
    public struct Config {
        public init(
            label: String,
            start: Roulette.Angle,
            end: Roulette.Angle,
            fill: Color = .secondarySystemBackground,
            stroke: Color = .systemGray,
            content: (() -> AnyView)?
        ) {
            self.label = label
            self.start = start
            self.end = end
            self.fill = fill
            self.stroke = stroke
            self.content = content
        }

        let label: String
        let start: Roulette.Angle
        let end: Roulette.Angle
        let fill: Color
        let stroke: Color
        let content: (() -> AnyView)?
    }
}
