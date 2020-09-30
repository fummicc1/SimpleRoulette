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
    case run
    case pause
    case stop(part: RoulettePartType)
    case idle
}

public final class RouletteViewModel: ObservableObject {
    @Published var parts: [RoulettePartType] = []
    @Published private(set) var state: RouletteState = .idle
    @Published var currentAngle: CGFloat = 0
    var isAnimating: Bool {
        switch state {
        case .start, .pause, .stop, .idle:
            return false
        case .run:
            return true
        }
    }
    
    public init() { }
    
    func start() {
        state = .start
    }
    
    func stop() {
        var angle = currentAngle
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
                state = .stop(part: part)
                break
            }
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
}
