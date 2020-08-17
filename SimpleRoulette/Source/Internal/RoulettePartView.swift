//
//  RoulettePartView.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/08/18.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation
import UIKit

class RoulettePartView: UIView {
    
    let part: RoulettePartType
    private weak var shapeLayer: RoulettePartShapeLayer?
    private weak var textLayer: RoulettePartTextLayer?
    
    init(frame: CGRect, part: RoulettePartType) {
        self.part = part
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // reset layer.
        shapeLayer?.removeFromSuperlayer()
        textLayer?.removeFromSuperlayer()
        
        // configure layer.
        // must configure shapeLayer before textLayer because of the layer-hierarcy.
        configureShapeLayer(RoulettePartShapeLayer(part: part), frame: rect)
        configureTextlayer(RoulettePartTextLayer(part: part), frame: rect)
    }
    
    private func assertFrame(_ frame: CGRect) {
        // check RouletteView is truely circular.
        assert(frame.size.width / 2 == frame.size.height / 2)
    }
    
    private func configureShapeLayer(_ layer: RoulettePartShapeLayer, frame: CGRect) {
        assertFrame(frame)
        let radius = frame.size.width / 2
        let center: CGPoint = .init(x: frame.midX, y: frame.midY)
        let path: UIBezierPath = .init()
        path.move(to: center)
        path.addArc(withCenter: center, radius: radius, startAngle: CGFloat(part.startRadianAngle), endAngle: CGFloat(part.endRadianAngle), clockwise: true)
        
        layer.path = path.cgPath
        layer.lineWidth = 2
        layer.fillColor = part.fillColor.cgColor
        layer.strokeColor = part.strokeColor.cgColor
        layer.backgroundColor = UIColor.clear.cgColor
        layer.frame = frame
        
        self.layer.addSublayer(layer)
        shapeLayer = layer
    }
    
    private func configureTextlayer(_ layer: RoulettePartTextLayer, frame: CGRect) {
        assertFrame(frame)
        let radius = frame.size.width / 2
        // from -0.5pi to 1.5pi.
        let startAngle = part.startRadianAngle
        // from -0.5pi to 1.5pi.
        let endAngle = part.endRadianAngle
        let meanAngle = (startAngle + endAngle) / 2
        layer.alignmentMode = .center
        layer.foregroundColor = UIColor.label.cgColor
        layer.string = part.name
        layer.fontSize = 16
        let centerX: CGFloat = radius
        let centerY: CGFloat = radius
        let dx: CGFloat = radius / 2 * CGFloat(cos(meanAngle))
        let dy: CGFloat = radius / 2 * CGFloat(sin(meanAngle))
        layer.frame.size = layer.preferredFrameSize()
        layer.position = .init(x: centerX + dx, y: centerY + dy)
        self.textLayer = layer
        self.layer.addSublayer(layer)
    }
    
    func updateFrame(_ frame: CGRect) {
        self.frame = frame
        setNeedsDisplay()
    }
}
