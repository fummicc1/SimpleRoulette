//
//  RouletteWorker.swift
//  
//
//  Created by Fumiya Tanaka on 2022/02/06.
//

import Foundation
import SwiftUI

public class RouletteWorker {

    public var angle: Angle
    public var speed: SlotRouletteSpeed
    var timer: Timer?

    public init(
        angle: Angle,
        speed: SlotRouletteSpeed
    ) {
        self.angle = angle
        self.speed = speed
    }

    func start(callback: @escaping (Angle) -> Void) {
        if timer?.isValid ?? false {
            timer?.invalidate()
        }
        timer = Timer.scheduledTimer(withTimeInterval: 1 / speed.value, repeats: true, block: { timer in
            self.angle.degrees += 1
        })
    }

    func stop() {
        timer?.invalidate()
    }
}
