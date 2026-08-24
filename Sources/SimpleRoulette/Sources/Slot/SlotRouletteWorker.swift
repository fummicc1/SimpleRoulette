//
//  SlotRouletteWorker.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2022/02/06.
//

import Foundation
import SwiftUI

/// Worker for slot roulette animations.
///
/// - Note: This class is maintained for backward compatibility.
@available(*, deprecated, message: "Consider using RouletteWorker for unified animation management")
@MainActor
public final class SlotRouletteWorker: Sendable {

    private var value: Int = 0
    public var speed: SlotRouletteSpeed
    private var animationTask: Task<Void, Never>?

    public init(speed: SlotRouletteSpeed) {
        self.speed = speed
    }

    func start(callback: @escaping @MainActor (Int) -> Void) {
        animationTask?.cancel()

        animationTask = Task { @MainActor in
            let interval = 1.0 / speed.value
            let nanoseconds = UInt64(interval * 1_000_000_000)

            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: nanoseconds)
                guard !Task.isCancelled else { break }
                self.value += 1
                callback(self.value)
            }
        }
    }

    func stop() {
        animationTask?.cancel()
        animationTask = nil
        value = 0
    }
}
