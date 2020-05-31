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
    
    private(set) var parts: [RoulettePartType] = [] {
        didSet {
            let rect = bounds
            let radius = rect.width / 4
            
            var layers: [CATextLayer] = []
            
            for part in parts {
                let layer = CATextLayer()
                layer.foregroundColor = UIColor.white.cgColor
                layer.fontSize = 24
                layer.string = part.name
                layer.frame = .init(origin: .zero, size: layer.preferredFrameSize())
                
                let meanAngle = (part.startRadianAngle + part.endRadianAngle) / 2
                let dx: CGFloat = radius * CGFloat(cos(meanAngle))
                let dy: CGFloat = radius * CGFloat(sin(meanAngle))
                layer.position = .init(x: center.x + dx, y: center.y + dy)
                
                layers.append(layer)
            }
            self.nameLayers = layers
            setNeedsDisplay()
        }
    }
    private var nameLayers: [CATextLayer] = [] {
        didSet {
            oldValue.forEach { old in layer.sublayers?.removeAll(where: { sub in sub == old }) }
            for nameLayer in nameLayers {
                layer.addSublayer(nameLayer)
            }
        }
    }
    
    public override func draw(_ rect: CGRect) {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = rect.width / 2
        
        let path: UIBezierPath = .init()
        for part in parts {
            part.fillColor.setFill()
            part.strokeColor.setStroke()
            path.move(to: center)
            path.addArc(withCenter: center, radius: radius, startAngle: CGFloat(part.startRadianAngle), endAngle: CGFloat(part.endRadianAngle), clockwise: true)
            path.fill()
            path.stroke()
        }
    }
    
    public func update(parts: [RoulettePart]) {
        self.parts = parts
        setNeedsDisplay()
    }
    
    public func start(clockwise: Bool = true) {
        let animation: CABasicAnimation = .init(keyPath: "transform.rotation")
        animation.fromValue = 0.0
        animation.toValue = CGFloat.pi * 2
        animation.duration = 3
        animation.repeatCount = .greatestFiniteMagnitude
        layer.add(animation, forKey: "animation")
    }
}
