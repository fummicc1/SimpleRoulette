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
    private weak var timer: Timer?

    public init() { }

    public func start(
        speed: RouletteSpeed,
        from value: Double? = nil,
        callback: @escaping (Double) -> Void
    ) {
        if let value = value {
            self.value = value
        }

        if let timer = timer, timer.isValid {
            timer.invalidate()
        }

        let timer = Timer(timeInterval: 0.001, repeats: true) { [weak self] _ in
            guard let self = self else {
                return
            }
            self.value += speed.value * 0.001
            callback(self.value)
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
