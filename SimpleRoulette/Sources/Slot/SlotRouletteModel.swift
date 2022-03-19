//
//  SlotRouletteModel.swift
//  
//
//  Created by Fumiya Tanaka on 2022/02/06.
//

import Foundation
import SwiftUI
import Combine

public struct SlotRouletteState: Identifiable {

    public init(
        type: SlotRouletteState.Status = .ready,
        worker: RouletteWorker,
        speed: SlotRouletteSpeed,
        value: SlotRouletteItem,
        index: Int,
        result: SlotRouletteState.Result? = nil
    ) {
        self.type = type
        self.worker = worker
        self.speed = speed
        self.value = value
        self.index = index
        self.result = result
    }

    public var id: Int {
        index
    }

    public var type: Status
    public var worker: RouletteWorker
    public var speed: SlotRouletteSpeed
    public var value: SlotRouletteItem
    public var index: Int
    public var result: Result?
    public var angle: Angle = .zero
}

public extension SlotRouletteState {
    enum Status {
        case ready
        case running
        case finished
    }

    enum Result {
        case selected(String)
        case wrong
    }
}

public struct SlotRouletteItem {
    public init(value: String, foregroundColor: Color, backgroundColor: Color) {
        self.value = value
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
    }

    public var value: String
    public var foregroundColor: Color
    public var backgroundColor: Color
}

public class SlotRouletteModel: ObservableObject {

    public init(
        values: [SlotRouletteItem],
        count: Int,
        speed: SlotRouletteSpeed = .normal
    ) {
        self.values = values
        let start = values[0]
        states = (0..<count).map({ index in
            let worker = RouletteWorker(
                speed: .random()
            )
            return SlotRouletteState(
                worker: worker,
                speed: speed,
                value: start,
                index: index
            )
        })
    }

    @Published var states: [SlotRouletteState]
    private let values: [SlotRouletteItem]
    private let onDecideSubject: PassthroughSubject<[SlotRouletteState], Never> = .init()
    public var onDecide: AnyPublisher<[SlotRouletteState], Never> {
        onDecideSubject.eraseToAnyPublisher()
    }

    public func start() {
        for i in states.indices {
            let state = states[i]
            state.worker.start { angle in
                self.states[i].angle = angle
            }
        }
    }

    public func pause() { }

    public func resume() {}

    public func stop() {

    }
}
