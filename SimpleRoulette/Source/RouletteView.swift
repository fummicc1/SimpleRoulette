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
    private weak var pointView: UIView?
    public weak var delegate: RouletteViewDelegate?
    private(set) var pointSize: CGSize = .init(width: 32, height: 32) {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    private var radius: CGFloat {
        (bounds.height - pointSize.height) / 2
    }
    private var length: CGFloat {
        min(frame.size.width, frame.size.height - pointSize.height)
    }
    private weak var verticalStackView: UIStackView?
    
    private(set) var parts: [RoulettePartType] = [] {
        didSet {
            partViews = parts.map { RoulettePartView(frame: .init(origin: .zero, size: .init(width: length, height: length)), part: $0) }
        }
    }
    
    private var partViews: [RoulettePartView] = [] {
        didSet {
            if !oldValue.isEmpty {
                oldValue.forEach { $0.removeFromSuperview() }
            }
            partViews.forEach { self.containerView.addSubview($0) }
            self.containerView.updateIntrinsicContentSize(CGSize(width: length, height: length))
            layoutIfNeeded()
            setNeedsDisplay()
        }
    }
    
    private lazy var containerView: PartContainerView = {
        let view = PartContainerView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
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
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        partViews.forEach { $0.updateFrame(.init(origin: .zero, size: .init(width: length, height: length))) }
    }
    
    private func initializeView(pointView: UIView) {
        self.pointView = pointView
        let stackView = UIStackView(arrangedSubviews: [pointView, containerView])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        setLayout(stackView: stackView, pointView: pointView, containerView: containerView)
        self.verticalStackView = stackView
    }
    
    private func setLayout(stackView: UIStackView, pointView: UIView, containerView: PartContainerView) {
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        pointView.heightAnchor.constraint(equalToConstant: pointSize.height).isActive = true
        pointView.widthAnchor.constraint(equalToConstant: pointSize.width).isActive = true
        containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1).isActive = true
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
            setLayout(stackView: stackView, pointView: customView, containerView: containerView)
            setNeedsDisplay()
        }
    }
    public func configure(parts: [RoulettePartType]) {
        self.parts = parts
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
        containerView.layer.add(animation, forKey: "animation")
        
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
        guard let presentation = containerView.layer.presentation() else {
            return
        }
        let transform = presentation.transform
        containerView.layer.transform = transform
        containerView.layer.removeAnimation(forKey: "animation")
        
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
