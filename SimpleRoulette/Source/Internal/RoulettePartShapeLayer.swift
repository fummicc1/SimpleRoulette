//
//  RoulettePartLayer.swift
//  SimpleRoulette
//
//  Created by Fumiya Tanaka on 2020/07/17.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import UIKit

class RoulettePartShapeLayer: CAShapeLayer {
    let part: RoulettePartType!
    
    init(part: RoulettePartType) {
        self.part = part
        super.init()
    }
    
    override init(layer: Any) {
        part = nil
        super.init(layer: layer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func ==(rhs: RoulettePartShapeLayer, lhs: RoulettePartShapeLayer) -> Bool {
        lhs.part.id == rhs.part.id
    }
}
