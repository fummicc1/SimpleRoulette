//
//  RouletteView.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/05/29.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation
import UIKit

public protocol RouletteViewDelegate: AnyObject {
    func rouletteView(_ rouletteView: RouletteView, didStopAt part: RoulettePartType)
}

public class RouletteView: UIView {
    
    public private(set) var isAnimating: Bool = false
    private weak var pointView: RoulettePointView?
    public weak var delegate: RouletteViewDelegate?
    public var pointSize: CGSize = .init(width: 32, height: 32) {
        didSet {
            setNeedsLayout()
        }
    }
    
    private(set) var parts: [RoulettePartType] = [] {
        didSet {
            let rect = bounds
            let radius = rect.width / 4
            
            for (index, part) in parts.enumerated() {
                let layer = CATextLayer()
                layer.foregroundColor = UIColor.white.cgColor
                layer.fontSize = 24
                layer.string = part.name
                layer.frame = .init(origin: .zero, size: layer.preferredFrameSize())
                
                var startAngle = part.startRadianAngle.accurate()
                let endAngle = part.endRadianAngle.accurate()
                let meanAngle = (startAngle + endAngle).value / 2
                let dx: CGFloat = radius * CGFloat(cos(meanAngle))
                let dy: CGFloat = radius * CGFloat(sin(meanAngle))
                layer.position = .init(x: center.x + dx, y: center.y + dy)
                
                if layers.count > index {
                    layers[index].textLayer = layer
                } else {
                    layers.append(RouletteLayerData(circleShapeLayer: nil, textLayer: layer))
                }
            }
            setNeedsDisplay()
        }
    }
    private var layers: [RouletteLayerData] = [] {
        didSet {
            oldValue.forEach { old in partContentLayer?.sublayers?.removeAll(where: { $0 == old.contentLayer }) }
            layers.forEach { $0.createContentLayer(rect: self.bounds) }
            layers.compactMap { $0.contentLayer }.forEach {
                self.partContentLayer?.addSublayer($0)                
            }
        }
    }
    private var partContentLayer: CAShapeLayer? = {
        let layer:  CAShapeLayer = .init()
        layer.strokeColor = UIColor.systemGray4.cgColor
        return layer
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        let pointView: RoulettePointView = .init(frame: .zero)
        self.pointView = pointView
        layer.addSublayer(partContentLayer!)
        addSubview(pointView)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        let pointView: RoulettePointView = .init(frame: .zero)
        self.pointView = pointView
        layer.addSublayer(partContentLayer!)
        addSubview(pointView)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        partContentLayer?.bounds = bounds
        // Note: position uses anchorPoint but frame does not.
        partContentLayer?.position = center
        pointView?.frame = .init(origin: .init(x: frame.midX - pointSize.width / 2, y: frame.midY - frame.width / 2 - pointSize.height), size: pointSize)
    }
    
    public override func draw(_ rect: CGRect) {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = rect.width / 2
        
        var layers: [RouletteLayerData] = self.layers
        
        // MARK: Content
        for (index, part) in parts.enumerated() {
            let path: UIBezierPath = .init()
            path.move(to: center)
            path.addArc(withCenter: center, radius: radius, startAngle: CGFloat(part.startRadianAngle), endAngle: CGFloat(part.endRadianAngle), clockwise: true)
            
            let partLayer: CAShapeLayer = .init()
            partLayer.path = path.cgPath
            partLayer.lineWidth = 2
            partLayer.fillColor = part.fillColor.cgColor
            partLayer.strokeColor = part.strokeColor.cgColor
            partLayer.frame = bounds
            partLayer.backgroundColor = UIColor.clear.cgColor
            
            if layers.count > index {
                layers[index].circleShapeLayer = partLayer
            } else {
                layers.append(RouletteLayerData(circleShapeLayer: partLayer, textLayer: nil))
            }
        }
        self.layers = layers
    }
    
    public func configure(parts: [RoulettePartType]) {
        self.parts = parts
        setNeedsDisplay()
    }
    
    public func start(clockwise: Bool = true) {
        let animation: CABasicAnimation = .init(keyPath: "transform.rotation")
        animation.fromValue = 0.0
        animation.toValue = CGFloat.pi * 2
        animation.duration = 3
        animation.repeatCount = .greatestFiniteMagnitude
        partContentLayer?.add(animation, forKey: "animation")
        isAnimating = true
    }
    
    public func stop() {
        
        
        func checkIfContainsPoint(from source: CGFloat, to destination: CGFloat, point: CGFloat) -> Bool {
            var point = point
            if destination - point > CGFloat.pi * 2 {
                point += CGFloat.pi * 2
            }
            if point - destination > CGFloat.pi * 2 {
                point -= CGFloat.pi * 2
            }
            print("Point: \(point.degree())")
            return source <= point && destination > point
        }
        
        guard let delegate = delegate else {
            fatalError("No Delegate")
        }
        guard let presentation = partContentLayer?.presentation() else {
            return
        }
        let transform = presentation.transform
        partContentLayer?.transform = transform
        partContentLayer?.removeAnimation(forKey: "animation")
        isAnimating = false
        
        var angle: CGFloat = atan2(transform.m12, transform.m11)
        
        if angle < 0 {
            angle += CGFloat.pi * 2
        }
        
        if angle > CGFloat.pi * 2 {
            angle -= CGFloat.pi * 2
        }
        
        print("Angle: \(angle.degree())")

        for part in parts {
            let start = part.startRadianAngle + Double(angle)
            let end = part.endRadianAngle + Double(angle)
            print("start: \(start.degree())")
            print("end: \(end.degree())")
            
            if checkIfContainsPoint(from: CGFloat(start), to: CGFloat(end), point: CGFloat.pi * 1.5) {
                delegate.rouletteView(self, didStopAt: part)
            }
        }
    }
}

extension RouletteView: RoulettePartHugeDelegate {
    public var total: Double {
        Double.pi * 2
    }
    
    public var allHuge: [Roulette.HugePart.Kind] {
        parts.map { $0 as! Roulette.HugePart }.map { $0.huge }
    }
}
