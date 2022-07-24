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
        worker: SlotRouletteWorker,
        speed: SlotRouletteSpeed,
        values: [SlotRouletteItem],
        index: Int,
        result: SlotRouletteState.Result? = nil
    ) {
        self.type = type
        self.worker = worker
        self.speed = speed
        self.values = values
        self.index = index
        self.result = result
    }

    public var id: Int {
        index
    }

    public var type: Status
    public var worker: SlotRouletteWorker
    public var speed: SlotRouletteSpeed
    public var values: [SlotRouletteItem]
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

public struct SlotRouletteItem: Identifiable {
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

public class SlotRouletteModel: ObservableObject {

    public init(
        values: [SlotRouletteItem],
        count: Int,
        speed: SlotRouletteSpeed = .normal
    ) {
        let worker = SlotRouletteWorker(
            speed: .random()
        )
        state = SlotRouletteState(
            worker: worker,
            speed: speed,
            values: values,
            index: 0
        )
    }

    @Published var state: SlotRouletteState
    private let onDecideSubject: PassthroughSubject<[SlotRouletteState], Never> = .init()
    public var onDecide: AnyPublisher<[SlotRouletteState], Never> {
        onDecideSubject.eraseToAnyPublisher()
    }

    public func start() {
        state.worker.start { angle in
            self.state.angle = .degrees(Double(angle))
        }
    }

    public func pause() { }

    public func resume() {}

    public func stop() {
        state.worker.stop()
    }
}
