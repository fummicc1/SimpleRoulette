//
//  RouletteLayerData.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/06/01.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import Foundation
import UIKit

class RouletteLayerData {
    weak var circleShapeLayer: CAShapeLayer?
    weak var textLayer: CATextLayer?
    
    private(set) weak var contentLayer: CALayer?
    
    init(circleShapeLayer: CAShapeLayer?, textLayer: CATextLayer?) {
        self.circleShapeLayer = circleShapeLayer
        self.textLayer = textLayer
    }
    
    @discardableResult
    func createContentLayer(rect: CGRect) -> CALayer? {
        guard let textLayer = textLayer, let circleShapeLayer = circleShapeLayer else {
            return nil
        }
        let contentLayer: CALayer = .init()
        contentLayer.addSublayer(circleShapeLayer)
        contentLayer.addSublayer(textLayer)
        contentLayer.frame = rect
        self.contentLayer = contentLayer
        return contentLayer
    }
}
