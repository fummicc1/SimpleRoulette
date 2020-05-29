//
//  RouletteView.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/05/29.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation
import UIKit

class RouletteView: UIView {
    
    private(set) var parts: [RoulettePart] = []
    
    override func draw(_ rect: CGRect) {
        let center = self.center
        let radius: Double = Double(frame.width / 2)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        let total = parts.reduce(0, { $0 + $1.value })
        for part in parts {
            let ratio: Double = part.value / total
            let angle = Double(CGFloat(360).radian()) * ratio
            let x = radius * cos(angle)
            let y = radius * sin(angle)
        }
    }
    
    public func update(parts: [RoulettePart]) {
        self.parts = parts
        setNeedsLayout()
    }
}
