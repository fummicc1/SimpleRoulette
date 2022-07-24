//
//  RouletteWorker.swift
//  
//
//  Created by Fumiya Tanaka on 2022/02/06.
//

import Foundation
import SwiftUI

public class RouletteWorker {

    private var value: Double = 0
    private var automaticallyStopAfter: Double?
    private weak var timer: Timer?

    public init() { }

    public func start(
        speed: RouletteSpeed,
        from value: Double? = nil,
        automaticallyStopAfter: Double?,
        callback: @escaping (Double) -> Void,
        onEnd: @escaping () -> Void
    ) {
        self.value = value ?? 0
        self.automaticallyStopAfter = automaticallyStopAfter

        if let timer = timer, timer.isValid {
            timer.invalidate()
        }

        let timer = Timer(timeInterval: 0.001, repeats: true) { [weak self] _ in
            guard let self = self else {
                return
            }
            self.value += speed.value * 0.001
            callback(self.value)

            if var automaticallyStopAfter = self.automaticallyStopAfter {
                automaticallyStopAfter -= 0.001
                if automaticallyStopAfter <= 0 {
                    onEnd()
                }
                self.automaticallyStopAfter = automaticallyStopAfter
            }
        }
        RunLoop.current.add(timer, forMode: .common)

        self.timer = timer
    }

    public func stop() {
        value = 0
        timer?.invalidate()
    }

    public func pause() {
        timer?.invalidate()
    }
}
