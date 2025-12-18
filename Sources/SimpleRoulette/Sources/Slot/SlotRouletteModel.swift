//
//  SlotRouletteModel.swift
//
//
//  Created by Fumiya Tanaka on 2022/02/06.
//

import Foundation
import SwiftUI

/// State for a single slot roulette component.
public struct SlotRouletteState: Identifiable, Sendable {

    public init(
        type: SlotRouletteState.Status = .ready,
        speed: RouletteSpeed,
        values: [SlotRouletteItem],
        index: Int,
        result: SlotRouletteState.Result? = nil
    ) {
        self.type = type
        self.speed = speed
        self.values = values
        self.index = index
        self.result = result
    }

    public var id: Int {
        index
    }

    public var type: Status
    public var speed: RouletteSpeed
    public var values: [SlotRouletteItem]
    public var index: Int
    public var result: Result?
    public var angle: Angle = .zero
}

public extension SlotRouletteState {
    enum Status: Sendable {
        case ready
        case running
        case finished
    }

    enum Result: Sendable {
        case selected(String)
        case wrong
    }
}

/// Item displayed in a slot roulette.
public struct SlotRouletteItem: Identifiable, Sendable {
    public init(value: String, foregroundColor: Color, backgroundColor: Color) {
        self.value = value
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
    }

    public var id: String {
        value
    }

    public var value: String
    public var foregroundColor: Color
    public var backgroundColor: Color
}

/// Model for managing slot roulette animations.
@Observable
@MainActor
public final class SlotRouletteModel {

    public init(
        values: [SlotRouletteItem],
        count: Int,
        speed: RouletteSpeed = .normal
    ) {
        state = SlotRouletteState(
            speed: speed,
            values: values,
            index: 0
        )
    }

    public var state: SlotRouletteState
    private let worker: RouletteWorker = .init()

    /// Callback invoked when the roulette decides on a result.
    public var onDecide: (([SlotRouletteState]) -> Void)?

    public func start() {
        state.type = .running
        let speed = state.speed
        Task { @MainActor in
            let stream = worker.start(speed: speed)
            for await degrees in stream {
                self.state.angle = .degrees(degrees)
            }
            self.state.type = .finished
        }
    }

    public func pause() {
        worker.pause()
    }

    public func resume() {
        start()
    }

    public func stop() {
        worker.stop()
        state.type = .finished
        onDecide?([state])
    }
}
