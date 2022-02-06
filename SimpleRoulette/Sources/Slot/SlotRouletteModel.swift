//
//  SlotRouletteModel.swift
//  
//
//  Created by Fumiya Tanaka on 2022/02/06.
//

import Foundation
import SwiftUI
import Combine

public struct SlotRouletteState {

    public init(
        type: SlotRouletteState.`Type` = .ready,
        speed: SlotRouletteSpeed = .normal,
        value: String,
        index: Int,
        result: SlotRouletteState.Result = .yet
    ) {
        self.type = type
        self.speed = speed
        self.value = value
        self.index = index
        self.result = result
    }

    public var type: `Type`
    public var speed: SlotRouletteSpeed
    public var value: String
    public var index: Int
    public var result: Result
}

public extension SlotRouletteState {
    enum `Type` {
        case ready
        case running
        case finished
    }

    enum Result {
        case yet
        case selected
        case wrong
    }
}

public class SlotRouletteModel: ObservableObject {

    public init(values: [String]) {
        states = values.enumerated().map({ (index, value) in
            SlotRouletteState(value: value, index: index)
        })
        workers = values.indices.map({ _ in 
            RouletteWorker()
        })
    }

    private var states: [SlotRouletteState]
    private var workers: [RouletteWorker]
    private let onDecideSubject: PassthroughSubject<[SlotRouletteState], Never> = .init()
    public var onDecide: AnyPublisher<[SlotRouletteState], Never> {
        onDecideSubject.eraseToAnyPublisher()
    }

    public func start() {

    }

    public func pause() { }

    public func resume() {}

    public func stop() {

    }
}
