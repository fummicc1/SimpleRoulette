//
//  RouletteWorker.swift
//  
//
//  Created by Fumiya Tanaka on 2022/02/06.
//

import Foundation
import SwiftUI

public class RouletteWorker {

    enum State {
        case resumed
        case suspended
    }

    private var value: Double = 0
    private var timerSource: DispatchSourceTimer?
    private var state: State = .suspended
    private var callback: ((Double) -> Void)?
    public var discardChange: Bool = false

    public init() { }

    deinit {
        reset()
    }

    private func reset() {
        timerSource?.setEventHandler(handler: { })
        timerSource?.cancel()
        resume()
        callback = nil
    }

    public func start(
        speed: RouletteSpeed,
        from value: Double? = nil,
        callback: @escaping (Double) -> Void
    ) {
        self.callback = callback

        if let value = value {
            self.value = value
        }

        let timerSource: DispatchSourceTimer
        if let _timerSource = self.timerSource {
            timerSource = _timerSource
        } else {
            timerSource = DispatchSource.makeTimerSource()
            self.timerSource = timerSource
        }
        timerSource.schedule(deadline: .now(), repeating: 1 / speed.value)
        timerSource.setEventHandler(handler: { [weak self] in
            guard let self = self else {
                return
            }
            if self.discardChange {
                return
            }
            self.value += 1
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                if self.discardChange {
                    return
                }
                callback(self.value)
            }
        })
        resume()
    }

    public func stop() {
        value = 0
        suspend()
    }

    public func pause() {
        suspend()
    }

    func resume() {
        if state == .resumed {
            return
        }
        discardChange = false
        state = .resumed
        timerSource?.resume()
    }

    func suspend() {
        if state == .suspended {
            return
        }
        discardChange = true
        state = .suspended
        timerSource?.suspend()
    }
}
