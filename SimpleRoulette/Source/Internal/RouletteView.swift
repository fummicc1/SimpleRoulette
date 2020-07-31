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

public enum RouletteMode {
    case normal
}

public class RouletteView: UIView {
    public private(set) var isAnimating: Bool = false
    private weak var pointView: UIView?
    public weak var delegate: RouletteViewDelegate?
    public var pointSize: CGSize = .init(width: 32, height: 32) {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    public var mode: RouletteMode = .normal
    private var radius: CGFloat {
        (bounds.height - pointSize.height) / 2
    }
    private weak var verticalStackView: UIStackView?
    
    private(set) var parts: [RoulettePartType] = [] {
        didSet {
            
            for part in parts {
                let layer = RoulettePartTextLayer()
                layer.part = part
                layer.foregroundColor = UIColor.label.cgColor
                layer.string = part.name
                layer.fontSize = 16
                let startAngle = part.startRadianAngle
                let endAngle = part.endRadianAngle
                let meanAngle = (startAngle + endAngle) / 2
                let centerX: CGFloat = radius / 2
                let centerY: CGFloat = radius / 2
                let dx: CGFloat = radius / 2 * CGFloat(cos(meanAngle))
                let dy: CGFloat = radius / 2 * CGFloat(sin(meanAngle))
                layer.position = .init(x: centerX + dx, y: centerY + dy)
                layer.frame.size = layer.preferredFrameSize()
                partContentView.layer.addSublayer(layer)
            }
            setNeedsDisplay()
        }
    }
    
    private var partContentView: PartContentView = {
        let view = PartContentView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView(pointView: createRoulettePointView())
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeView(pointView: createRoulettePointView())
    }
    
    private func initializeView(pointView: UIView) {
        self.pointView = pointView
        let stackView = UIStackView(arrangedSubviews: [pointView, partContentView])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        setLayout(stackView: stackView, pointView: pointView, partContentView: partContentView)
        self.verticalStackView = stackView
    }
    
    private func setLayout(stackView: UIStackView, pointView: UIView, partContentView: PartContentView) {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        pointView.heightAnchor.constraint(equalToConstant: pointSize.height).isActive = true
        pointView.widthAnchor.constraint(equalToConstant: pointSize.width).isActive = true
        partContentView.heightAnchor.constraint(equalTo: partContentView.widthAnchor, multiplier: 1).isActive = true
    }
    
    public func setPointView(_ customView: UIView, size: CGSize) {
        if let pointView = pointView {
            verticalStackView?.removeArrangedSubview(pointView)
            pointView.removeFromSuperview()
        }
        verticalStackView?.insertArrangedSubview(customView, at: 0)
        pointView = customView
        pointSize = size
        if let stackView = verticalStackView {
            setLayout(stackView: stackView, pointView: customView, partContentView: partContentView)
            setNeedsDisplay()
        }
    }
    
    public override func draw(_ rect: CGRect) {
        let center = CGPoint(x: radius, y: radius)
        
        // MARK: Content
        for part in parts {
            let path: UIBezierPath = .init()
            path.move(to: center)
            path.addArc(withCenter: center, radius: radius, startAngle: CGFloat(part.startRadianAngle), endAngle: CGFloat(part.endRadianAngle), clockwise: true)
            
            let partLayer: RoulettePartShapeLayer = .init()
            partLayer.path = path.cgPath
            partLayer.lineWidth = 2
            partLayer.fillColor = part.fillColor.cgColor
            partLayer.strokeColor = part.strokeColor.cgColor
            partLayer.backgroundColor = UIColor.clear.cgColor
            partLayer.frame = partContentView.bounds
            
            partContentView.layer.insertSublayer(partLayer, at: 0)
        }
    }
    
    public func configure(parts: [RoulettePartType]) {
        self.parts = parts
        setNeedsLayout()
        setNeedsDisplay()
    }
    
    public func start(duration: Double = 2, clockwise: Bool = true, animated: Bool = true) {
        let animation: CABasicAnimation = .init(keyPath: "transform.rotation")
        if animated {
            animation.timingFunction = .init(name: .easeInEaseOut)
        }
        animation.fromValue = 0.0
        animation.toValue = CGFloat.pi * 2
        animation.duration = duration
        animation.repeatCount = .greatestFiniteMagnitude
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        partContentView.layer.add(animation, forKey: "animation")
        
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
        guard let presentation = partContentView.layer.presentation() else {
            return
        }
        let transform = presentation.transform
        partContentView.layer.transform = transform
        partContentView.layer.removeAnimation(forKey: "animation")
        
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
    
    private func createRoulettePointView() -> RoulettePointView {
        let pointView: RoulettePointView = .init(frame: .zero, size: pointSize)
        pointView.translatesAutoresizingMaskIntoConstraints = false
        pointView.backgroundColor = .clear
        return pointView
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
