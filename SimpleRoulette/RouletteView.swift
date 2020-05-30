//
//  RouletteView.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/05/29.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation
import UIKit

public class RouletteView: UIView {
    
    private(set) var parts: [RoulettePart] = []
    
    public override func draw(_ rect: CGRect) {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = rect.width / 2
        
        let path: UIBezierPath = .init()
        for part in parts {
            part.fillColor.setFill()
            part.strokeColor.setStroke()
            path.move(to: center)
            path.addArc(withCenter: center, radius: radius, startAngle: CGFloat(part.startAngle.value), endAngle: CGFloat(part.endAngle.value), clockwise: true)
            path.fill()
            path.stroke()
        }
    }
    
    public func update(parts: [RoulettePart]) {
        self.parts = parts
        setNeedsDisplay()
    }
}
