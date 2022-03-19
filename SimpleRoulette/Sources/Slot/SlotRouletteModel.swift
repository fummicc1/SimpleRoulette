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
        value: String,
        index: Int,
        result: SlotRouletteState.Result = .yet
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
    public var value: String
    public var index: Int
    public var result: Result

    func getAngle() {

    }
}

public extension SlotRouletteState {
    enum Status {
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

    public init(
        values: [String],
        count: Int,
        speed: SlotRouletteSpeed = .normal
    ) {
        self.values = values
        let start = values[0]
        states = (0..<count).map({ index in
            let worker = RouletteWorker(
                angle: .zero,
                speed: .normal
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
    private let values: [String]
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
