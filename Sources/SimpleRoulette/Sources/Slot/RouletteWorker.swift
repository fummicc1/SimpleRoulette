//
//  RouletteWorker.swift
//  
//
//  Created by Fumiya Tanaka on 2022/02/06.
//

import Foundation
import SwiftUI

public class RouletteWorker {

    private var value: Int = 0
    public var speed: SlotRouletteSpeed
    var timer: Timer?

    public init(
        speed: SlotRouletteSpeed
    ) {
        self.speed = speed
    }

    func start(callback: @escaping (Int) -> Void) {
        if timer?.isValid ?? false {
            timer?.invalidate()
        }
        timer = Timer.scheduledTimer(withTimeInterval: 1 / speed.value, repeats: true, block: { timer in
            self.value += 1
            callback(self.value)
        })
    }

    func stop() {
        timer?.invalidate()
    }
}
